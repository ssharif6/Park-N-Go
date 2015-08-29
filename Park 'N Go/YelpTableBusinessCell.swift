//
//  YelpTableBusinessCell.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 8/28/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit

class YelpTableBusinessCell: UITableViewCell {
    
    @IBOutlet weak var thumbIMageView: UIImageView!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var business: Business! {
        didSet {
            nameLabel.text = business.name
            let thumbImageViewData = NSData(contentsOfURL: business.imageURL!)
            thumbIMageView.image = UIImage(data: thumbImageViewData!)
            let ratingsData = NSData(contentsOfURL: business.ratingImageURL!)
            ratingsImageView.image = UIImage(data: ratingsData!)
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            distanceLabel.text = business.distance
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbIMageView.layer.cornerRadius = 3
        thumbIMageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
