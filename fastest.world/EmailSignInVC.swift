//
//  EmailSignInVC.swift
//  fastest.world
//
//  Created by RamR on 9/24/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EmailSignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailSignInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                /* User signed in successfully*/
                if error == nil {
                    print("VIK: User authenticated with Firebase")
                } else {
                    print(error)
                    /* Creating an account if it does not exist */
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("VIK: Unable to create an account \(error)")
                        } else {
                            print("VIK: Successfully authenticated with Firebase using email")
                        }
                    })
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
