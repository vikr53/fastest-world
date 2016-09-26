//
//  EmailSignUpVC.swift
//  fastest.world
//
//  Created by RamR on 9/25/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import Firebase

class EmailSignUpVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
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
        if let uname = self.usernameField.text, let email = self.emailField.text, let pwd = self.pwdField.text, let confirmedPwd = self.pwdConfirmField.text {
    
            //Checking if username has been used before
            uname
            
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                            case .errorCodeInvalidEmail:
                                //modal with description of error
                                print("VIK: The email entered is invalid")
                            case .errorCodeEmailAlreadyInUse:
                                print("VIK: The email entered is already in use")
                            case .errorCodeWeakPassword:
                                print("VIK: User entered a weak password. Password is less than 6 chars")
                            default:
                                //modal just saying there is an error
                                print("VIK: Error occurred while attempting to sign in with Firebase")
                        }
                    }
                } else {
                    //No error occured
                    print("User successfully created an account with fastest-world")
                    //enter username and email into your own database
                }
            })
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
