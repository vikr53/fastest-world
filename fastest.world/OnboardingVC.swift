//
//  OnboardingVC.swift
//  fastest.world
//
//  Created by RamR on 11/26/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVC: UIViewController, PaperOnboardingDataSource {

    @IBOutlet weak var onboardingView: OnboardingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
       /* 
         Yellow - UIColor(red:0.99, green:0.91, blue:0.36, alpha:1.0)
         Orange - UIColor(red:0.98, green:0.47, blue:0.31, alpha:1.0)
         Blue - UIColor(red:0.29, green:0.57, blue:0.87, alpha:1.0)
         Dark Gray Background - UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
         */
        let backgroundColorOne = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)
        
        return (imageName: "lightningPoints", title: "A Great Start", description: "Please play my app. Goddamit it is great.", iconName: "", color: backgroundColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!)
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
