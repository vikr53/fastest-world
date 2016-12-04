//
//  OnboardingVC.swift
//  fastest.world
//
//  Created by RamR on 11/26/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVC: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    @IBOutlet weak var gotItBtn: UIButton!

    @IBOutlet weak var onboardingView: OnboardingView!

    //first page stuff
//    var backgroundColorOne = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
//    var titleFont = UIFont(name: "AvenirNext-Bold", size: 24)
//    var descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)
    
    var pages = [OnboardingItemInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
       /*
         Yellow - UIColor(red:0.99, green:0.91, blue:0.36, alpha:1.0)
         Orange - UIColor(red:0.98, green:0.47, blue:0.31, alpha:1.0)
         Blue - UIColor(red:0.29, green:0.57, blue:0.87, alpha:1.0)
         Dark Gray Background - UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
         */
        
        pages = [(imageName: "Logo", title: "Welcome to fastest.world!", description: "How bad do you want to be called the \"Fastest Human in the World\"?", iconName: "Logo", color: UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0), titleColor: UIColor.yellow, descriptionColor: UIColor.white, titleFont: UIFont(name: "Copperplate", size: 22)!, descriptionFont: UIFont(name: "Copperplate", size: 18)!),
                 
                 (imageName: "homeInfographic", title: "Home Page", description: "Everything is accessible through the home page" , iconName: "Logo", color: UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0), titleColor: UIColor(red:0.99, green:0.91, blue:0.36, alpha:1.0), descriptionColor: UIColor.white, titleFont: UIFont(name: "Copperplate", size: 24)!, descriptionFont: UIFont(name: "Copperplate", size: 18)!),
                 
                 (imageName: "playingGameGraphic", title: "Objective", description: "Tap the screen as soon as the colored arc appears. \n Blue = 5 points \n Orange = 3 points \n Yellow = 2 points \n Get 40 points to progress to the next level!" , iconName: "holdingLightningGraphic", color: UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0), titleColor: UIColor(red:0.29, green:0.57, blue:0.87, alpha:1.0), descriptionColor: UIColor.white, titleFont: UIFont(name: "Copperplate", size: 24)!, descriptionFont: UIFont(name: "Copperplate", size: 18)!),
            
                (imageName: "medalsInfographic", title: "Medals", description: "The type of medal you hold tells you where you stand against other players", iconName: "smallOrangeBadge", color: UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0), titleColor: UIColor(red:0.98, green:0.47, blue:0.31, alpha:1.0), descriptionColor: UIColor.white, titleFont: UIFont(name: "Copperplate", size: 24)!, descriptionFont: UIFont(name: "Copperplate", size: 18)!)
        
                ]
        
        return pages[index]
    }
    
    @IBAction func gotStarted(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingComplete")
        
        userDefaults.synchronize()
        
    }

    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2 {
            if self.gotItBtn.alpha == 1 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.gotItBtn.alpha = 0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            UIView.animate(withDuration: 0.5, animations: {
                self.gotItBtn.alpha = 1
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
