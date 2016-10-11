//
//  CustomCell.swift
//  fastest.world
//
//  Created by RamR on 10/8/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var medalImage: UIImageView!
    @IBOutlet weak var unameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userRank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
