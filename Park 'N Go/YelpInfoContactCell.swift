//
//  YelpInfoContactCell.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 8/29/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit

class YelpInfoContactCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var business: Business! {
        didSet {
            // thumbImage for side
            phoneNumberLabel.text = business.phone
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
