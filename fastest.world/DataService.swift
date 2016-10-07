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
    private var doesExist = false
    
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
    
    func updatePoints(points: Int) {
        
        var dbRetreivedPoints: Int = 0
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        //get current points
        _REF_SCORES.observeSingleEvent(of: .value, with: { snapshot in
            print(uid!)
            if let dbpoints = snapshot.value?[uid!] as? Int {
                //Setting Points - Username
                dbRetreivedPoints = dbpoints
                print(dbRetreivedPoints)
            } else {
                //not there
                dbRetreivedPoints = 0
            }
            
            let updatedPoints = points + dbRetreivedPoints
            let userData: Dictionary<String, Int> = [ uid!: updatedPoints ]
            self._REF_SCORES.updateChildValues(userData)
        })
    }
    
    func doesUserExist(uid: String) -> Bool {
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
    }
}
