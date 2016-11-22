//
//  StatsVC.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 10/11/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit
import Firebase


class StatsVC: UIViewController {
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    var pointsEarned: Int = 0
    var bonusPointsEarned: Int = 0
    var usersSamePoints: Int = 0
    var totalNoAt: Int = 0
    var refStats: FIRDatabaseReference = FIRDatabase.database().reference().child("stats")
    
    var shouldDisplayAd: Bool = false
    var interstitial: GADInterstitial!
    
    var scores: [String] = []
    var scoreData: [Int] = []

    override func viewDidAppear(_ animated: Bool) {
        if shouldDisplayAd {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("VIK: Add was not ready")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set points label
        self.pointsLabel.text = String(self.pointsEarned)
        self.pointsLabel.isHidden = false
        //set bonus label
        self.bonusLabel.text = String(self.bonusPointsEarned)
        self.bonusLabel.isHidden = false
        //set total points label
        self.totalPointsLabel.text = String(self.pointsEarned + self.bonusPointsEarned)
        self.totalPointsLabel.isHidden = false
        
        //begin animating button
        var homeAnimImages = [UIImage]()
        homeAnimImages.append(UIImage(named: "homeAnim1")!)
        homeAnimImages.append(UIImage(named: "homeAnim2")!)
        homeAnimImages.append(UIImage(named: "homeAnim3")!)
        homeAnimImages.append(UIImage(named: "homeAnim4")!)
        homeAnimImages.append(UIImage(named: "homeAnim5")!)
        homeAnimImages.append(UIImage(named: "homeAnim6")!)
        homeAnimImages.append(UIImage(named: "homeAnim7")!)
        homeAnimImages.append(UIImage(named: "homeAnim8")!)
        
        homeBtn.setImage(homeAnimImages[0], for: UIControlState.normal)
        homeBtn.imageView!.animationImages = homeAnimImages
        homeBtn.imageView!.animationDuration = 0.9
        homeBtn.imageView!.startAnimating()
        
        //determine if ad should be displayed and load or not load the ad
        if shouldDisplayAd {
            self.createAndLoadInterstitial()
        }
        
        print("VIK: \(pointsEarned)")

        //get stats from the database
        /*refStats.observeSingleEvent(of: .value, with: { snapshot in
            print("VIK: There are \(snapshot.childrenCount) in stats node")
            let enumerator = snapshot.children
            var counter: Int = 0
            
            while let givenPoint = enumerator.nextObject() as? FIRDataSnapshot {
                print("VIK: While loop Stats VC entered")
                let pointKey = Int(givenPoint.key)
                if let noUsersAtGivenPoint = givenPoint.value as? Int {
                    if self.pointsEarned == pointKey! {
                        print("VIK: \(noUsersAtGivenPoint)")
                        self.usersSamePoints = noUsersAtGivenPoint
                        self.totalNoAt = self.totalNoAt + noUsersAtGivenPoint
                        //Add to data array
                        self.scores.append(String(pointKey!))
                        self.scoreData.append(noUsersAtGivenPoint)
                    } else {
                        self.totalNoAt = self.totalNoAt + noUsersAtGivenPoint
                        //Add to data array
                        self.scores.append(String(pointKey!))
                        self.scoreData.append(noUsersAtGivenPoint)
                    }
                }
                counter = counter + 1
            }
            
            print("VIK: Array of scores \(self.scores)")
            print("VIK: Array of scoreData \(self.scoreData)")
            
            print("VIK: \(self.usersSamePoints)")
            print("VIK: \(self.totalNoAt)")
            
            //stats calc
            var percentage: Double = 0.0
            print("VIK: \(Double(self.usersSamePoints)/Double(self.totalNoAt))")
            percentage = (1.0 - Double(self.usersSamePoints)/Double(self.totalNoAt)) * 100
            
            
            
            //set percentage label
            self.percentageLabel.text = String(format: "%.1f", percentage) + "%"
            self.percentageLabel.isHidden = false
        })*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6428150896277982/2683783956")
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
    }
    
    @IBAction func returnBtnPressed(_ sender: AnyObject) {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            } else {
                // No user is signed in.
                self.performSegue(withIdentifier: "goToSignIn", sender: nil)
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

}
