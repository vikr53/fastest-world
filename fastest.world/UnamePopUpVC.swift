//
//  UnamePopUpVC.swift
//  fastest.world
//
//  Created by RamR on 10/2/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import Firebase

class UnamePopUpVC: UIViewController {

    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var errorMsgField: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    //reference to database
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.withAlphaComponent(UIColor.black)(0.6)

        // Do any additional setup after loading the view.
        self.unameField.text = FIRAuth.auth()?.currentUser?.displayName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitUname(_ sender: AnyObject) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let uname = unameField.text!
        let userData = [ "uname": uname ]
        //Check if username exists
        ref.queryOrdered(byChild: "uname").queryEqual(toValue: uname).observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: entered")
            if snapshot.exists() == true {
                print("VIK: snapshot exists")
                print("Already used")
                
                /* Error text field change, change text field, and remove check image*/
                self.errorMsgField.text = "Already Exists"
                self.errorMsgField.textColor = UIColor.red
                self.errorMsgField.isHidden = false
                self.checkImage.isHidden = true
                
                self.changeField(textField: self.unameField)
                self.unameField.addTarget(self, action: #selector(UnamePopUpVC.changeFieldBack(_:)), for: UIControlEvents.editingChanged)
            } else {
                print("VIK: snapshot does not exist")
                
                DataService.ds.updateFirebaseDBUser(uid: uid!, userData: userData)
                self.performSegue(withIdentifier: "goToHome", sender: nil)
                self.view.removeFromSuperview()
            }
        })
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
