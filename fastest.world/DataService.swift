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
    
    /*func doesUsernameExist(username: String) -> Bool {
        var exist: Bool = true
        print("VIK: Arrived at exist")
        _REF_USERS.queryOrdered(byChild: "uname").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: entered")
            if snapshot.exists() == true {
                print("VIK: snapshot exists")
            } else {
                print("VIK: snapshot does not exist")
                exist =
            }
        })
        print("exist var value: \(exist)")
        return exist
    }*/
}
