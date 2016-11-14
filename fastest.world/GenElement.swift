//
//  GenElement.swift
//  fastest.world
//
//  Created by Vikram Ramanathan on 10/1/16.
//  Copyright © 2016 Vikram Ramanathan. All rights reserved.
//

import UIKit

class GenElement: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}
