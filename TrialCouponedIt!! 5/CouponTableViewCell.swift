//
//  CouponTableViewCell.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/16/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var couponImageView: UIImageView!
   
    @IBOutlet weak var couponNameLabel: UILabel!
    
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
