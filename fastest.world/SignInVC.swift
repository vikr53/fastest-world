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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_UID) {
            print("VIK: Found ID in keychain")
            performSegue(withIdentifier: "goToHome", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToSetUname", sender: nil)
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
                if let user = user {
                    let userData = ["uname": user.displayName!, "provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String> ) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
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

