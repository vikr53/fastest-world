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

    override func viewDidLoad() {
        super.viewDidLoad()

        //get stats from the database
        refStats.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var counter: Int = 0
            
            while let givenPoint = enumerator.nextObject() as? FIRDataSnapshot {
                let pointKey = Int(givenPoint.key)
                if let noUsersAtGivenPoint = givenPoint.value as? Int {
                    if self.pointsEarned == pointKey! {
                        self.usersSamePoints = noUsersAtGivenPoint
                        self.totalNoAt = self.totalNoAt + noUsersAtGivenPoint
                    } else {
                        self.totalNoAt = self.totalNoAt + noUsersAtGivenPoint
                    }
                }
                counter = counter + 1
            }
            
            //stats calc
            var percentage: Double = 0.0
            percentage = 100.0 - Double(self.usersSamePoints/self.totalNoAt)
            
            //set percentage label
            self.percentageLabel.text = "\(percentage)%"
            
            //set comment label
            if percentage > 90 && percentage < 100 {
                self.commentLabel.text = "Damn son... Take a chill pill"
            } else if percentage > 70 && percentage < 90 {
                self.commentLabel.text = "Almost there"
            } else if percentage > 50 && percentage < 70 {
                self.commentLabel.text = "Practice makes perfect"
            } else if percentage > 0 && percentage < 50 {
                self.commentLabel.text = "You are faster than that and you know it"
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
