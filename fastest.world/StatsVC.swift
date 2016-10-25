//
//  StatsVC.swift
//  fastest.world
//
//  Created by RamR on 10/11/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import Firebase

class StatsVC: UIViewController {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var pointsEarned: Int = 0
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
        
        //determine if ad should be displayed and load or not load the ad
        if shouldDisplayAd {
            self.createAndLoadInterstitial()
        }
        
        print("VIK: \(pointsEarned)")

        //get stats from the database
        refStats.observeSingleEvent(of: .value, with: { snapshot in
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
            
            //set comment label
            let intPercentage = Int(percentage)
            print("Percentage converted to int = \(intPercentage)")
            if intPercentage >= 90 && intPercentage <= 100 {
                self.commentLabel.text = "\"Damn son... Take a chill pill\""
                self.commentLabel.isHidden = false
            } else if intPercentage >= 70 && intPercentage < 90 {
                self.commentLabel.text = "\"Almost there\""
                self.commentLabel.isHidden = false
            } else if intPercentage >= 50 && intPercentage < 70 {
                self.commentLabel.text = "\"Practice makes perfect\""
                self.commentLabel.isHidden = false
            } else if intPercentage >= 0 && intPercentage < 50 {
                self.commentLabel.text = "\"You are faster than that and you know it\""
                self.commentLabel.isHidden = false
            } else {
                print("VIK: ERROR. Did not satisfy any of the above conditions ")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
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
