//
//  GameVC.swift
//  fastest.world
//
//  Created by RamR on 10/3/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameVC: UIViewController {

    @IBOutlet weak var targetTimeLabel: UILabel!
    @IBOutlet weak var userTimeLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var stimulusView: RoundedCornerView!
    
    var timer: Timer = Timer()
    var userTimeCount: Double = 0.00
    var targetTime: Double = 0.50
    var points: Int = 0
    var hasPresentedStimulus: Bool = false
    var earlyTapped: Bool = false
    
    var receivedUname:String = ""
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* self.targetTimeLabel.alpha = 0.0
        self.targetTimeLabel.text = String(targetTime) */
        
        self.userTimeLabel.text = "-.--"
        self.pointsLabel.text = String(0)
        
        print("VIK2: \(receivedUname)")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /* Game Setup -
         1) targetTimeInterval - delayed animation of the time [ 0.50 seconds ]
         
         */
        super.viewDidAppear(animated)
        
        self.startGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gameAreaTapped(_ sender: AnyObject) {
        if self.hasPresentedStimulus {
            self.timer.invalidate()
            print(userTimeCount)
            
            //set stimulusView back to regular color
            self.stimulusView.backgroundColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.0)
            self.hasPresentedStimulus = false
            
            //check if it beat the target time
            //round target and userTimeCount
            userTimeCount = Double(round(100*userTimeCount)/100)
            targetTime = Double(round(100*targetTime)/100)
            if (userTimeCount <= targetTime) {
                //update points
                print(targetTime)
                switch(targetTime){
                case 0.50:
                    points += 1
                case 0.45:
                    points += 2
                case 0.40:
                    points += 3
                case 0.35:
                    points += 4
                case 0.30:
                    points += 5
                case 0.25:
                    points += 6
                case 0.20:
                    points += 7
                case 0.15:
                    points += 8
                case 0.10:
                    points += 9
                case 0.05:
                    points += 10
                    //user won!
                    //send points data to firebase
                    DataService.ds.updatePoints(points: points, uname: receivedUname)
                    //update attempts
                    DataService.ds.updateAttempts()
                        //perform segue to stats page
                        self.performSegue(withIdentifier: "goToStats", sender: nil)
                default:
                    print("Some error has occured or user has finished the game")
                }
                targetTime -= 0.05
                startGame()
            } else {
                //end the game - move to popup
                print("VIK: You failed")
            }
        } else {
            //early tap
            print("VIK: You tapped early!")
            self.earlyTapped = true
            
            //let user know the result
            self.userTimeLabel.text = "Early Tap"
            self.userTimeLabel.textAlignment = .center
            self.userTimeLabel.sizeToFit()
            
            //send points data to firebase
            DataService.ds.updatePoints(points: points, uname: receivedUname)
            //update attempts
            DataService.ds.updateAttempts()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                //perform segue to stats page
                self.performSegue(withIdentifier: "goToStats", sender: nil)
            //}

        }
    }

    func startGame() {
        print("VIK: Started the game")
        userTimeCount = 0
        
        self.userTimeLabel.text = "-.--"
        self.pointsLabel.text = String(points)
        
        self.targetTimeLabel.alpha = 0.0
        self.targetTimeLabel.text = String(format: "%.2f", targetTime)
        
        print("VIK: About to animate")
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.targetTimeLabel.alpha = 1.0
            }, completion: nil)
        print("VIK: finished animating")
        
        //assign a random number and delay the stimuli by that time
        let random = drand48() * 3 + 2
        DispatchQueue.main.asyncAfter(deadline: .now() + random) {
            if (!self.earlyTapped) {
                print("VIK: Entered the delayed loop")
                self.stimulusView.backgroundColor = UIColor.yellow
                self.hasPresentedStimulus = true
                self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameVC.updateUserTimer), userInfo: nil, repeats: true)
            }
        }

    }
    
    func updateUserTimer() {
        if userTimeCount <= targetTime {
            userTimeCount += 0.01
            self.userTimeLabel.text = String(format: "%.2f", userTimeCount)
        } else {
            self.timer.invalidate()
            userTimeCount = 1.0
            self.stimulusView.backgroundColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.0)
            //send points data to firebase
            DataService.ds.updatePoints(points: points, uname: receivedUname)
            //update number of attempts in firebase db
            DataService.ds.updateAttempts()
            //pause
            //perform segue to stats page
            self.performSegue(withIdentifier: "goToStats", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rand = drand48() * 3
        print("VIK: Random number that determines ad display - \(rand)")
        if rand < 2.0 {
            print("VIK: Ad will be shown")
            let secondVC: StatsVC = segue.destination as! StatsVC
            secondVC.shouldDisplayAd = true
            secondVC.pointsEarned = points
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
