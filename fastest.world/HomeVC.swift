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
    @IBOutlet weak var attemptsImageView: UIImageView!
    @IBOutlet weak var medalImageView: UIImageView!
    @IBOutlet weak var medalTypeImageView: UIImageView!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var animationViewPoints: UIImageView!
    @IBOutlet weak var animationViewAttempts: UIImageView!
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    var dbUname: String = ""
    private var rank: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let refSpecificUser : FIRDatabaseReference = FIRDatabase.database().reference().child("users").child(uid!)
        let refScores: FIRDatabaseReference = FIRDatabase.database().reference().child("scores")
        
        let imgListArray: [UIImage] = [UIImage(named: "lightningAnim01")!,UIImage(named: "lightningAnim02")! ,UIImage(named: "lightningAnim03")!, UIImage(named: "lightningAnim04")!, UIImage(named: "lightningAnim05")!, UIImage(named: "lightningAnim06")!]
        self.animationView.animationImages = imgListArray
        self.animationView.animationDuration = 0.5
        self.animationView.startAnimating()
        
        self.animationViewPoints.animationImages = imgListArray
        self.animationViewPoints.animationDuration = 0.5
        self.animationViewPoints.startAnimating()
        
        self.animationViewAttempts.animationImages = imgListArray
        self.animationViewAttempts.animationDuration = 0.5
        self.animationViewAttempts.startAnimating()
        
        //Set Title - Username, Score, Medal
        refSpecificUser.observeSingleEvent(of: .value, with: { snapshot in
            if let username = (snapshot.value as? NSDictionary)?["uname"] as? String {
                self.dbUname = username
                print("VIK: Set the username just now")
                //Setting Title - Username
                self.unameLabel.text = username
                self.unameLabel.isHidden = false
                
            }
            
            refScores.queryOrderedByValue().observe(FIRDataEventType.value, with: { snapshot in
                print("There are \(snapshot.childrenCount) scores")
                let enumerator = snapshot.children
                var rankCounter = 0
    
                //check if already add and act accordingly
                print("VIK2: \(self.dbUname) -> self.dbUname")
                print("VIK2: score = \((snapshot.value as? NSDictionary)?[self.dbUname])")
                if let userScore = (snapshot.value as? NSDictionary)?[self.dbUname] as? Int {
                    print("VIK2: User Score exists = \(userScore)")
                } else {
                    print("VIK2: User Score does not exist")
                    //also give points = 0
                    
                    let userData2: Dictionary<String, Int> = [self.dbUname: 0]
                    refScores.updateChildValues(userData2)
                }
                
                while let score = enumerator.nextObject() as? FIRDataSnapshot {
                    print(score.value)
                    rankCounter = rankCounter + 1
                    if self.dbUname == score.key {
                        let convertedScore = -(score.value! as! Int)
                        print("VIK: \(score.key)")
                        print("VIK: \(convertedScore)")
                        self.userScoreLabel.text = String(convertedScore)
                        
                        //stop animating
                        self.animationViewPoints.stopAnimating()
                        self.animationViewPoints.isHidden = true
                        
                        self.userScoreLabel.isHidden = false
                        
                        print("VIK: User rank is \(rankCounter)")
                        self.rank = rankCounter
                        
                    }
                }
                //give appropriate medal
                if (self.rank > 0) && (self.rank <= 10) {
                    print("VIK: User has earned a blue medal")
                    self.medalImageView.image = UIImage(named: "blueBadge")
                    self.medalTypeImageView.image = UIImage(named: "blueHighlighted")
                    self.medalImageView.isHidden = false
                    self.medalTypeImageView.isHidden = false
                    
                    //stop animating
                    self.animationView.stopAnimating()
                    self.animationView.isHidden = true
                } else if (self.rank <= 100) && (self.rank >= 10) {
                    print("VIK: User has earned a orange medal")
                    self.medalImageView.image = UIImage(named: "orangeBadge")
                    self.medalTypeImageView.image = UIImage(named: "orangeHighlighted")
                    self.medalImageView.isHidden = false
                    self.medalTypeImageView.isHidden = false
                    
                    //stop animating
                    self.animationView.stopAnimating()
                    self.animationView.isHidden = true
                } else {
                    print("VIK: User has earned an yellow medal")
                    self.medalImageView.image = UIImage(named: "yellowBadge")
                    self.medalTypeImageView.image = UIImage(named: "yellowHighlighted")
                    self.medalImageView.isHidden = false
                    self.medalTypeImageView.isHidden = false
                    
                    //stop animating
                    self.animationView.stopAnimating()
                    self.animationView.isHidden = true
                }
                /*for child in snapshot.children {
                 if let score = child.value(forKey: uid!) as! [FIRDataSnapshot] {
                 self.userScoreLabel.text = String(score)
                 self.userScoreLabel.isHidden = false
                 }
                 }*/
            })
            
            //Setting attempts
            refSpecificUser.observe(FIRDataEventType.value, with: { snapshot in
                if let currentAttempts = (snapshot.value as? NSDictionary)?["attempts"] as? String {
                    print("VIK: \(currentAttempts) current attempts")
                    self.attemptsImageView.image = UIImage(named: "\(currentAttempts)Attempt")
                    self.attemptsImageView.isHidden = false
                    print("VIK: changed attemptsImageView")
                    
                    //stop animating
                    self.animationViewAttempts.stopAnimating()
                    self.animationViewAttempts.isHidden = true
                } else {
                    print("VIK: Some error occured trying to get the number of attempts left")
                }
            })
            
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("VIK: \(segue.destination)")
        if(segue.identifier == "goToLeaderboard") {
            let secondVC: LeaderboardVC = segue.destination as! LeaderboardVC
            secondVC.receivedUname = self.dbUname
        } else if (segue.identifier == "goToGame") {
            let secondVC: GameVC = segue.destination as! GameVC
            secondVC.receivedUname = self.dbUname
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
