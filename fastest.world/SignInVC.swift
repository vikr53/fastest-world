//
//  ViewController.swift
//  fastest.world
//
//  Created by RamR on 9/10/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("VIK: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("VIK: User cancelled Facebook Authentication")
            } else {
                print("VIK: Successfully authenticate with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("VIK: Unable to authenticate with Firebase - \(error)")
            } else {
                print("VIK: Successfully authenticated with Firebase")
            }
        })
    }

}

