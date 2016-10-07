//
//  HomeVC.swift
//  fastest.world
//
//  Created by RamR on 9/25/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class HomeVC: UIViewController {

    @IBOutlet weak var unameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    
    private var rankCounter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var uid = FIRAuth.auth()?.currentUser?.uid
        let refSpecificUser : FIRDatabaseReference = FIRDatabase.database().reference().child("users").child(uid!)
        let refScores: FIRDatabaseReference = FIRDatabase.database().reference().child("scores")
        //let refUser : FIRDatabaseReference = FIRDatabase.database().reference().child("users")
        
        //Set Title - Username, Score, Medal
        refSpecificUser.observeSingleEvent(of: .value, with: { snapshot in
            if let username = snapshot.value?["uname"] as? String {
                //Setting Title - Username
                self.unameLabel.text = username
                self.unameLabel.isHidden = false
            }
        })
        
        // Set Ranking and Score - get top hundred and if instance of uid is not there just give yellow medal
        refScores.queryOrderedByValue().observe(FIRDataEventType.value, with: { snapshot in
            print("There are \(snapshot.childrenCount) scores")
            let enumerator = snapshot.children
            while let score = enumerator.nextObject() as? FIRDataSnapshot {
                print(score.value)
                self.rankCounter += 1
                if uid! == score.key {
                    self.userScoreLabel.text = String(score.value!)
                    self.userScoreLabel.isHidden = false
                    
                    print("VIK: User rank is \(self.rankCounter)")
                }
            }
            /*for child in snapshot.children {
                if let score = child.value(forKey: uid!) as! [FIRDataSnapshot] {
                    self.userScoreLabel.text = String(score)
                    self.userScoreLabel.isHidden = false
                }
            }*/
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        print("VIK: Status of key removal from keychain: \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
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
