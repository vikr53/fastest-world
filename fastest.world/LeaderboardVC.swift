//
//  LeaderboardVC.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 10/8/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    var receivedUname: String = ""
    
    var unames = [String]()
    var scores = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref.child("scores").queryOrderedByValue().queryLimited(toFirst: 200).observe(.value, with: { snapshot in
            self.unames = []
            self.scores = []
            print("VIKl: There are \(snapshot.childrenCount) scores")
            let enumerator = snapshot.children
            var count: Int = 0
            while let score = enumerator.nextObject() as? FIRDataSnapshot {
                print("VIKl: \(count)")
                print("VIKl: \(score.key)")
                print("VIKl: \(score.value!)")
                self.unames.append(score.key)
                self.scores.append(String(-(score.value as! Int)))
                print("VIKl: \(self.unames[0])")
                count = count + 1
            }
            print("VIKl: Users - \(self.unames)")
            print("VIKl: Scores - \(self.scores)")
            self.tableView.reloadData()
        })
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("VIKl : Count - \(unames.count)")
        
        return unames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("VIKl: Entered the tableview func")
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        var cellBorderColor: UIColor = UIColor.yellow
        print("VIKl: \(indexPath.row)")
        if indexPath.row >= 0 && indexPath.row < 10 {
            cell.medalImage.image = UIImage(named: "smallBlueBadge")
            cell.unameLabel.text = unames[indexPath.row]
            
            cell.userScoreLabel.text = scores[indexPath.row]
            cell.userScoreLabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
            
            cell.userRank.text = String(indexPath.row + 1)
            cell.userRank.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
            
            cellBorderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
        } else if indexPath.row >= 10 && indexPath.row < 99 {
            cell.medalImage.image = UIImage(named: "smallOrangeBadge")
            cell.unameLabel.text = unames[indexPath.row]
        
            cell.userScoreLabel.text = scores[indexPath.row]
            cell.userScoreLabel.textColor = UIColor(red:0.98, green:0.48, blue:0.28, alpha:1.0)
                
            cell.userRank.text = String(indexPath.row + 1)
            cell.userRank.textColor = UIColor(red:0.98, green:0.48, blue:0.28, alpha:1.0)
            
            cellBorderColor = UIColor(red:0.98, green:0.48, blue:0.28, alpha:1.0)
        } else {
            cell.medalImage.image = UIImage(named: "smallyellowBadge")
            cell.unameLabel.text = unames[indexPath.row]
            
            cell.userScoreLabel.text = scores[indexPath.row]
            cell.userScoreLabel.textColor = UIColor.yellow
            
            cell.userRank.text = String(indexPath.row + 1)
            cell.userRank.textColor = UIColor.yellow
            cellBorderColor = UIColor(red:0.99, green:0.91, blue:0.36, alpha:1.0)
        }
        
        if receivedUname == unames[indexPath.row] {
            //found user
            //change cell border
            cell.layer.borderColor = cellBorderColor.cgColor
            cell.layer.borderWidth = 2.0
        } else {
            cell.layer.borderColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.0).cgColor
        }
        
       
        
        return cell
    }

    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            
            delayCounter += 1
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
