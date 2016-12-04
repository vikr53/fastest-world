//
//  HomeVC.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 9/25/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Foundation
import AVFoundation

class HomeVC: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var unameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var attemptsImageView: UIImageView!
    @IBOutlet weak var medalImageView: UIImageView!
    @IBOutlet weak var medalTypeImageView: UIImageView!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var animationViewPoints: UIImageView!
    @IBOutlet weak var animationViewAttempts: UIImageView!
    @IBOutlet weak var watchAdBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var lightningBoltView: UIImageView!
    @IBOutlet weak var playDotView: UIImageView!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var useLightningPtsBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var lightPts: Int = 0
    var userAttempts: String = "0"

    var backgroundMusicPlayer: AVAudioPlayer = AVAudioPlayer()
    let url = Bundle.main.url(forResource: "bgMusic", withExtension: "mp3")
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    var timer: Timer = Timer()
    var timeLeft: Int = 0
    var noAttemptsClockCount: Int = 0
    
    var interstitial: GADInterstitial!
    
    var dbUname: String = ""
    private var rank: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createAndLoadInterstitial()
        
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
                        self.bestScoreLabel.text = String(convertedScore)
                        
                        //stop animating
                        self.animationViewPoints.stopAnimating()
                        self.animationViewPoints.isHidden = true
                        
                        self.bestScoreLabel.isHidden = false
                        
                        print("VIK: User rank is \(rankCounter)")
                        self.rank = rankCounter
                    }
                }
                
                /*
                 Yellow - UIColor(red:0.99, green:0.91, blue:0.36, alpha:1.0)
                 Orange - UIColor(red:0.98, green:0.47, blue:0.31, alpha:1.0)
                 Blue - UIColor(red:0.29, green:0.57, blue:0.87, alpha:1.0)
                 Dark Gray Background - UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
                 */
                
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
                    
                    //set rank number
                    self.userRankLabel.text = String(self.rank)
                    self.userRankLabel.textColor = UIColor(red:0.29, green:0.57, blue:0.87, alpha:1.0)
                    self.userRankLabel.isHidden = false
                } else if (self.rank <= 100) && (self.rank >= 10) {
                    print("VIK: User has earned a orange medal")
                    self.medalImageView.image = UIImage(named: "orangeBadge")
                    self.medalTypeImageView.image = UIImage(named: "orangeHighlighted")
                    self.medalImageView.isHidden = false
                    self.medalTypeImageView.isHidden = false
                    
                    //stop animating
                    self.animationView.stopAnimating()
                    self.animationView.isHidden = true
                    
                    //set rank number
                    self.userRankLabel.text = String(self.rank)
                    self.userRankLabel.textColor = UIColor(red:0.98, green:0.47, blue:0.31, alpha:1.0)
                    self.userRankLabel.isHidden = false
                } else {
                    print("VIK: User has earned an yellow medal")
                    self.medalImageView.image = UIImage(named: "yellowBadge")
                    self.medalTypeImageView.image = UIImage(named: "yellowHighlighted")
                    self.medalImageView.isHidden = false
                    self.medalTypeImageView.isHidden = false
                    
                    //stop animating
                    self.animationView.stopAnimating()
                    self.animationView.isHidden = true
                    
                    //set rank number
                    self.userRankLabel.text = String(self.rank)
                    self.userRankLabel.textColor = UIColor(red:0.99, green:0.91, blue:0.36, alpha:1.0)
                    self.userRankLabel.isHidden = false
                }
                /*for child in snapshot.children {
                 if let score = child.value(forKey: uid!) as! [FIRDataSnapshot] {
                 self.userScoreLabel.text = String(score)
                 self.userScoreLabel.isHidden = false
                 }
                 }*/
            })
            
            refSpecificUser.child("lightning_points").observe(FIRDataEventType.value, with: { snapshot in
                if let lightningPoints = snapshot.value as? Int {
                    //exists
                    self.lightPts = lightningPoints
                    self.userScoreLabel.text = String(self.lightPts)
                    self.userScoreLabel.isHidden = false
                    //check attempts
                    //Setting attempts
                    refSpecificUser.child("attempts").observe(FIRDataEventType.value, with: { snapshot in
                        if let currentAttempts = snapshot.value as? String {
                            self.userAttempts = currentAttempts
                            print("VIK: \(currentAttempts) current attempts")
                            
                            if Int(self.userAttempts)! > 0 {
                                self.attemptsImageView.image = UIImage(named: "\(self.userAttempts)Attempt")
                                self.attemptsImageView.isHidden = false
                                print("VIK: changed attemptsImageView")
                            } else {
                                //need to buy attempts and the stop-clock should start
                                //present buy button and the clock - 30 min
                                self.watchAdBtn.isHidden = false
                                //disable play btn and change the color of the elements to gray
                                self.playBtn.isEnabled = false
                                self.lightningBoltView.image = UIImage(named: "greyLightningBolt")
                                self.playDotView.image = UIImage(named: "greyDot")
                                //self.timeLeftFunc()
                                //check if user has enough lightning points
                                
                                
                                //exists - decide whether user can use lightning points
                                print("VIKo: lightning points - \(self.lightPts)")
                                if self.lightPts >= 350 {
                                    self.useLightningPtsBtn.isEnabled = true
                                } else {
                                    //set lightning use points to disabled and grey
                                    self.useLightningPtsBtn.isEnabled = false
                                    let image = UIImage(named: "greyUseLightningPts") as UIImage?
                                    self.useLightningPtsBtn.setImage(image, for: .normal)
                                }
                                
                                self.useLightningPtsBtn.isHidden = false
                                self.orLabel.isHidden = false
                            }

                            //stop animating
                            self.animationViewAttempts.stopAnimating()
                            self.animationViewAttempts.isHidden = true
                        } else {
                            print("VIK: Some error occured trying to get the number of attempts left")
                        }
                    })
                } else {
                    self.userScoreLabel.text = String(self.lightPts)
                    self.userScoreLabel.isHidden = false
                }
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Play Background Music
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            print("VIK: Playing")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.removeObject(forKey: KEY_UID)
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
            let secondVC: GameViewController = segue.destination as! GameViewController
            secondVC.receivedUname = self.dbUname
        }
        
        //Stop music
        print("VIKm: Performing a segue right now")
        if(backgroundMusicPlayer.isPlaying) {
            print("VIKm: Currently playing")
            backgroundMusicPlayer.pause()
            print("VIKm: paused the music")
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        //play music once again
        backgroundMusicPlayer.play()
    }
    
    @IBAction func watchAdBtnTapped(_ sender: AnyObject) {
        if self.interstitial.isReady {
            //pause music
            backgroundMusicPlayer.pause()
            self.interstitial.present(fromRootViewController: self)
            //endTimer and add attempts
            self.timeLeft = -1
            //updateAttemptsClockTimer()
        } else {
            print("VIK: Add was not ready")
        }
        
        //change the stuff graphics in attempts box
        self.watchAdBtn.isHidden = true
        
        let refUsers : FIRDatabaseReference = FIRDatabase.database().reference().child("users").child(uid!)
        
        let userData2: Dictionary<String, String> = ["attempts": "5"]
        refUsers.updateChildValues(userData2)
        
        self.useLightningPtsBtn.isHidden = true
        self.orLabel.isHidden = true
        self.watchAdBtn.isHidden = true
        
        self.attemptsImageView.image = UIImage(named: "5Attempt")
        self.attemptsImageView.isHidden = false
        
        self.playBtn.isEnabled = true
        self.lightningBoltView.image = UIImage(named: "lightningBolt")
        self.playDotView.image = UIImage(named: "yellowDot")
    }

    
//    func timeLeftFunc() {
//        let refSpecificUser : FIRDatabaseReference = FIRDatabase.database().reference().child("users").child(uid!)
//        
//        //check if time left already exists
//        let timeNow = UInt64(floor(NSDate().timeIntervalSince1970))
//        refSpecificUser.child("timeWhenDone").observeSingleEvent(of: .value, with: { snapshot in
//            if let dBRetTimeWhenDone = snapshot.value as? Int {
//                //exists
//                self.timeLeft = dBRetTimeWhenDone - Int(timeNow)
//                print("VIK3: timeLeft = \(self.timeLeft)")
//                //Start timer
//                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeVC.updateAttemptsClockTimer), userInfo: nil, repeats: true)
//            } else {
//                //it does not exist and should be created
//                self.timeLeft = (60*30)
//                let timeWhenDone = timeNow + (60*30)
//                print("VIK3: \(timeNow)")
//                //update timeWhenDone in db
//                let userData: Dictionary<String, Int> = ["timeWhenDone": Int(timeWhenDone)]
//                refSpecificUser.updateChildValues(userData)
//                //Start timer
//                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeVC.updateAttemptsClockTimer), userInfo: nil, repeats: true)
//            }
//        })
//        
//        
//    }
//    
//    func updateAttemptsClockTimer() {
//        if self.timeLeft > 0 {
//            //time is not up - stopwatch setup
//            self.timeLeft = self.timeLeft - 1
//            let minutes: Int = self.timeLeft/60
//            let seconds: Int = self.timeLeft - (minutes * 60)
//            let formattedMinutes = String(format: "%02d", minutes)
//            let formattedSeconds = String(format: "%02d", seconds)
//            print("VIK3: Minutes - \(formattedMinutes) Seconds - \(formattedSeconds)")
//            self.timeLeftLabel.text = "00:\(formattedMinutes):\(formattedSeconds)"
//            self.timeLeftLabel.isHidden = false
//            self.clockImage.isHidden = false
//        } else {
//            //time is up!
//            /*
//             1. timer invalidate
//             2. Add 5 attempts
//             3. Hide Clock, Label and button
//             4. Show attempts image
//             5. Enable the button/Change its color
//             6. Remove timeWhenDone child
//             */
//            self.timer.invalidate()
//            
//            let refUsers : FIRDatabaseReference = FIRDatabase.database().reference().child("users").child(uid!)
//            let userData2: Dictionary<String, String> = ["attempts": "5"]
//            refUsers.updateChildValues(userData2)
//            
//            self.clockImage.isHidden = true
//            self.timeLeftLabel.isHidden = true
//            self.watchAdBtn.isHidden = true
//            
//            self.attemptsImageView.image = UIImage(named: "5Attempt")
//            self.attemptsImageView.isHidden = false
//            
//            self.playBtn.isEnabled = true
//            self.lightningBoltView.image = UIImage(named: "lightningBolt")
//            self.playDotView.image = UIImage(named: "yellowDot")
//            
//            refUsers.child("timeWhenDone").removeValue()
//        }
//    }
    
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6428150896277982/4402692751")
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
    }
    
    @IBAction func useLightningPtsTapped(_ sender: Any) {
        //change lightning points in database
        let newLightPts: Int = lightPts - 350
        
        let userLightningPtsChanged = ["lightning_points": newLightPts]
        FIRDatabase.database().reference().child("users").child(uid!).updateChildValues(userLightningPtsChanged)
        
        //change the stuff graphics in attempts box
        self.watchAdBtn.isHidden = true
        
        let refUsers : FIRDatabaseReference = FIRDatabase.database().reference().child("users").child(uid!)
        
        let userData2: Dictionary<String, String> = ["attempts": "5"]
        refUsers.updateChildValues(userData2)
        
        self.useLightningPtsBtn.isHidden = true
        self.orLabel.isHidden = true
        self.watchAdBtn.isHidden = true
        
        self.attemptsImageView.image = UIImage(named: "5Attempt")
        self.attemptsImageView.isHidden = false
        
        self.playBtn.isEnabled = true
        self.lightningBoltView.image = UIImage(named: "lightningBolt")
        self.playDotView.image = UIImage(named: "yellowDot")
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
