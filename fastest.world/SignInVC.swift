//
//  ViewController.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 9/10/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var playNowBtn: UIButton!
    @IBOutlet var signInView: UIView!
    @IBOutlet weak var emailBtn: UIButton!
   
    @IBOutlet weak var fbBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("VIK: Found ID in keychain")
            performSegue(withIdentifier: "goToHome", sender: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        self.emailBtn.isEnabled = false
        self.playNowBtn.isEnabled = false
        self.fbBtn.isEnabled = false
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("VIK: Unable to authenticate with Facebook - \(error)")
                
                self.emailBtn.isEnabled = true
                self.playNowBtn.isEnabled = true
                self.fbBtn.isEnabled = true
                
            } else if result?.isCancelled == true {
                print("VIK: User cancelled Facebook Authentication")
                
                self.emailBtn.isEnabled = true
                self.playNowBtn.isEnabled = true
                self.fbBtn.isEnabled = true
                
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
                if let user = user {
                    let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                    let uid = user.uid
                    //check if user already exists
                    ref.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                        print("VIK: entered")
                        if snapshot.exists() == true {
                            //user already exists - continue to home page and add to keychain
                            print("VIK: user already exists")
                        
                            let keychainResult = KeychainWrapper.standard.set(uid, forKey: KEY_UID)
                            print("VIK: Data saved to keychain \(keychainResult)")
                            
                            self.performSegue(withIdentifier: "goToHome", sender: nil)
                        } else {
                            //user does not exist - create one
                            let userData = ["provider": credential.provider, "attempts" : String(5)]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    })
                }
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String> ) {
        //Check if current user exists in db
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)

        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("VIK: Data saved to keychain \(keychainResult)")

        /* The following pulls up the popup to set username*/
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbUnamePopUpID") as! UnamePopUpVC
        print(popOverVC)
        print(self.addChildViewController(popOverVC))
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
}

