//
//  ETATableViewCell.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 9/4/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit

class ETATableViewCell: UITableViewCell {

    @IBOutlet weak var etaTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
