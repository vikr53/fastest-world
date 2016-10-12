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
        
        //retreive the current stats
        self._REF_STATS.observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: enterd stats child")
            var dbRetreivedData: Int = 0
            print("VIK: User received \(points) points")
            print("VIK: \((snapshot.value as? NSDictionary)?[String(points)] as! Int)")
            if let noUsersForTimeLostAt = (snapshot.value as? NSDictionary)?[String(points)] as? Int {
                print("VIK: Number of users for points = \(noUsersForTimeLostAt)")
                dbRetreivedData = noUsersForTimeLostAt
                dbRetreivedData = dbRetreivedData + 1
            } else {
                print("VIK: Couldn't get any data")
                dbRetreivedData = 1
            }
            let userData: Dictionary<String, Int> = [ String(points): dbRetreivedData ]
            self._REF_STATS.updateChildValues(userData)
            print("VIK: Updated stat child")
        })
    
        //get current points
        self._REF_SCORES.observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: entered the update points db check")
            print("VIK2: \((snapshot.value as? NSDictionary)?[uname])")
            if let dbPoints = (snapshot.value as? NSDictionary)?[uname] as? Int {
                //Setting Points - Username
                print("VIK2: dbPoints \(dbPoints)")
                dbRetreivedPoints = dbPoints
                print(dbRetreivedPoints)
            } else {
                //not there
                dbRetreivedPoints = 0
                print("VIK: Making dbpoints 0")
            }
            
            //update scores branch
            print("VIK2: points earned = \(points)")
            let updatedPoints: Int = -points + dbRetreivedPoints
            print("VIK2: Updated points \(updatedPoints)")
            print("VIK2: \(uname)")
            let userData2: Dictionary<String, Int> = [String(uname): updatedPoints]
            self._REF_BASE.child("scores").updateChildValues(userData2)
            print("VIK2: Updated scores child")
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
    
    func updateAttempts(){
        
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
