//
//  EmailSignInVC.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 9/24/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EmailSignInVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailField.delegate = self
        self.pwdField.delegate = self
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func pwdtextFieldDidChange (_ textField: UITextField){
        
        textField.layer.borderColor = nil
        textField.backgroundColor = nil
        textField.textColor = UIColor.black
        textField.layer.borderWidth = 0.0
        
        
        //change email text field
        self.emailField.layer.borderColor = nil
        self.emailField.backgroundColor = nil
        self.emailField.textColor = UIColor.black
        self.emailField.layer.borderWidth = 0.0
        
    }

    func emailtextFieldDidChange (_ textField: UITextField){
        
        textField.layer.borderColor = nil
        textField.backgroundColor = nil
        textField.textColor = UIColor.black
        textField.layer.borderWidth = 0.0
        
        
        //change email text field
        self.pwdField.layer.borderColor = nil
        self.pwdField.backgroundColor = nil
        self.pwdField.textColor = UIColor.black
        self.pwdField.layer.borderWidth = 0.0
        
    }
    
    @IBAction func emailSignInTapped(_ sender: AnyObject) {

        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.pwdField.text!) { (user, error) in
            if error != nil {
                self.changeField(textField: self.pwdField)
                self.changeField(textField: self.emailField)
                
                //Password Field Changed
                self.pwdField.addTarget(self, action: #selector(EmailSignInVC.pwdtextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
                
                //Email Field Changed
                self.emailField.addTarget(self, action: #selector(EmailSignInVC.emailtextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
                
                print("VIK: Error Loging into fastest-world. May be because of the following reasons \n 1. Password is wrong 2. Email is of invalid type 3. Error connecting to and authenticating with Firebase")
            } else {
                print("VIK: Successfully autheticated with Firebase")
                if let user = user {
                   self.completeSignIn(id: user.uid)
                }
            }
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
    
    func completeSignIn(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("VIK: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
    func changeField (textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 5.0
        textField.backgroundColor = UIColor(red:1.00, green:0.30, blue:0.30, alpha:1.0)
        textField.textColor = UIColor.white
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
