//
//  leaderboardStyle.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 10/9/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit

class leaderboardStyle: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        self.clipsToBounds = false;
        self.layer.masksToBounds = false;
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
