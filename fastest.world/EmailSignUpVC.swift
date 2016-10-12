//
//  EmailSignUpVC.swift
//  fastest.world
//
//  Created by RamR on 9/25/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EmailSignUpVC: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var pwdConfirmField: UITextField!
    
    //reference to database
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpBtnTapped(_ sender: AnyObject) {
        if let email = self.emailField.text, let pwd = self.pwdField.text, let confirmedPwd = self.pwdConfirmField.text {
            
            if (pwd != confirmedPwd) {
                self.createErrorMessage(error: "Passwords do not match")
                self.errorMessage.isHidden = false
                print("Password entered in both fields do not match")
            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil {
                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                            case .errorCodeInvalidEmail:
                                //description of error
                                self.createErrorMessage(error: "The email entered is invalid")
                                self.errorMessage.isHidden = false
                                print("VIK: The email entered is invalid")
                            case .errorCodeEmailAlreadyInUse:
                                //description of error
                                self.createErrorMessage(error: "The email entered is already in use")
                                self.errorMessage.isHidden = false
                                print("VIK: The email entered is already in use")
                            case .errorCodeWeakPassword:
                                //description of error
                                self.createErrorMessage(error: "Weak Password")
                                self.errorMessage.isHidden = false
                                print("VIK: User entered a weak password. Password is less than 6 chars")
                            default:
                                //modal just saying there is an error
                                self.createErrorMessage(error: "Error while attempting to sign up")
                                //override the errorMessage text color
                                self.errorMessage.textColor = UIColor.red
                                self.errorMessage.isHidden = false
                                print("VIK: Error occurred while attempting to sign up with Firebase")
                            }
                        }
                    } else {
                        //Successfully created the user
                        print("User successfully created an account with fastest-world")
                        //enter username and email into your own database and sign the user in
                        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                print("Error signing the user in after creating an account")
                            } else {
                                print("Successfully signed the user in")
                                if let user = user {
                                    let userData = ["email": email, "provider": "Firebase", "attempts": String(5)]
                                    self.completeSignIn(id: user.uid, userData: userData)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
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
    
    func createErrorMessage(error: String) {
        //Error message modification
        self.errorMessage.text = error
        self.errorMessage.textColor = UIColor.white
        
        //Fields modification
        if error == "The email entered is invalid" {
            changeField(textField: emailField)
            
            //Listener to change back after edited
            self.emailField.addTarget(self, action: #selector(EmailSignUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
        } else if error == "Passwords do not match" {
            changeField(textField: pwdField)
            changeField(textField: pwdConfirmField)
            
            //Listeners to change back after edited
            self.pwdField.addTarget(self, action: #selector(EmailSignUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
            self.pwdConfirmField.addTarget(self, action: #selector(EmailSignUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
        } else if error == "The email entered is already in use" {
            changeField(textField: emailField)
            
            //Listener to change back after edited
            self.emailField.addTarget(self, action: #selector(EmailSignUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
        } else if error == "Weak Password" {
            changeField(textField: pwdField)
            changeField(textField: pwdConfirmField)
            
            //Listeners to change back after edited
            self.pwdField.addTarget(self, action: #selector(EmailSignUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
            self.pwdConfirmField.addTarget(self, action: #selector(EmailSignUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
        }
    }
    
    func changeField (textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 5.0
        textField.backgroundColor = UIColor(red:1.00, green:0.30, blue:0.30, alpha:1.0)
        textField.textColor = UIColor.white
    }

    func changeFieldBack(_ textField: UITextField) {
        textField.layer.borderColor = nil
        textField.backgroundColor = nil
        textField.textColor = UIColor.black
        textField.layer.borderWidth = 0.0
        
        //Makes sure both textFields are not highlighted after one is edited
        if textField == pwdField {
            pwdConfirmField.layer.borderColor = nil
            pwdConfirmField.backgroundColor = nil
            pwdConfirmField.textColor = UIColor.black
            pwdConfirmField.layer.borderWidth = 0.0
        } else if textField == pwdConfirmField {
            pwdField.layer.borderColor = nil
            pwdField.backgroundColor = nil
            pwdField.textColor = UIColor.black
            pwdField.layer.borderWidth = 0.0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
