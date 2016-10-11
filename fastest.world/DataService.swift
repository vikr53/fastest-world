//
//  DataService.swift
//  fastest.world
//
//  Created by RamR on 9/26/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_SCORES = DB_BASE.child("scores")
    private var _REF_STATS = DB_BASE.child("stats")
    //private var doesExist = false
    
    //getters since private variables
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }

    func updateFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updatePoints(points: Int, uname: String) {
        
        var dbRetreivedPoints: Int = 0
        
        //get current points
        _REF_SCORES.observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: entered the update points db check")
            if let dbpoints = snapshot.value?[uname] as? Int {
                //Setting Points - Username
                dbRetreivedPoints = dbpoints
                print(dbRetreivedPoints)
            } else {
                //not there
                dbRetreivedPoints = 0
            }
            
            //retreive the current stats
            self._REF_STATS.observeSingleEvent(of: .value, with: { snapshot in
                print("VIK: enterd stats child")
                var dbRetreivedData: Int = 0
                if let noUsersForTimeLostAt = snapshot.value?[points] as? Int {
                    print("VIK: Number of users for points = \(noUsersForTimeLostAt)")
                    dbRetreivedData = noUsersForTimeLostAt
                    dbRetreivedData = dbRetreivedData + 1
                } else {
                    print("VIK: Couldn't get any data")
                    dbRetreivedData = 1
                }
                let userData: Dictionary<Int, Int> = [ points: dbRetreivedData ]
                self._REF_STATS.updateChildValues(userData)
                print("VIK: Updated stat child")
            })
            
            //update scores branch
            let updatedPoints = -points + dbRetreivedPoints
            let userData: Dictionary<String, Int> = [ uname: updatedPoints ]
            self._REF_SCORES.updateChildValues(userData)
        })
    }
    
    /* func doesUserExist(uid: String) -> Bool {
        _REF_USERS.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                //user already exists
                print("VIK: Snapshot \(snapshot.value) exists")
                self.doesExist = true
                print("VIK \(self.doesExist)")
            } else {
                //user does not exist
                print("VIK: Snapshot \(snapshot.value) DOES NOT exist")
                self.doesExist = false
                print("VIK \(self.doesExist)")
            }
        })
        return doesExist
    } */
    
    func updateAttempts() {
        
        var dBRetreivedAttemtps: Int = 0
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        print("VIK: here")
        //get current attempts
        _REF_USERS.child(uid!).child("attempts").observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: now inside")
            print("VIK \(snapshot.value)")
            if let dbAttempts = snapshot.value as? String {
                //Attempts key exists
                dBRetreivedAttemtps = Int(dbAttempts)!
                print("VIK: The user had \(dBRetreivedAttemtps) before playing this game")
                let updatedAttempts = Int(dBRetreivedAttemtps) - 1
                let userData: Dictionary<String, String> = ["attempts": String(updatedAttempts)]
                self._REF_USERS.child(uid!).updateChildValues(userData)
            } else {
                //Attempts key does not exist
                dBRetreivedAttemtps = 0
                print("VIK: Attempts key does not exist")
            }
        })
        
    }
    
}
