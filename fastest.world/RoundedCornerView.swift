//
//  RoundedCornerView.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 10/2/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit

class RoundedCornerView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 4.0
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
