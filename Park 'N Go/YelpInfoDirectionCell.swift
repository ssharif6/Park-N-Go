//
//  YelpInfoDirectionCell.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 8/29/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit

class YelpInfoDirectionCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var business: Business! {
        didSet {
            addressLabel.text = business.displayAddress
            // thumbImage for side
            
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
