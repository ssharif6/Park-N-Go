//
//  YelpBusinessModel.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 8/16/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation

struct YelpBusinessCategory {
    var id: String
    var name: String
    var children: [YelpBusinessCategory]    // for hierarchical mapping
}


struct YelpBusinessModel {
    var id: String
    var name: String
    var imageURL: NSURL? = nil          // image_url
    var ratingsImageURL: NSURL? = nil   // rating_img_url
    var reviews: Int                    // review_count
    var location: NSDictionary          // location
    var distance: Double                // distance (meters)
    var categories: [YelpBusinessCategory] = []
    
    init(json: NSDictionary) {
        self.id = json["id"] as! String
        self.name = json["name"] as! String
        if let imageURL = json["image_url"] as? String {
            self.imageURL = NSURL(string: imageURL)
        }
        if let ratingsImageURL = json["rating_img_url"] as? String {
            self.ratingsImageURL = NSURL(string: ratingsImageURL)
        }
        self.reviews = json["review_count"] as? Int ?? 0
        self.location = json["location"] as? NSDictionary ?? [:]
        self.distance = (json["distance"] as? Double) ?? 0
        if let categories = json["categories"] as? NSArray {
            for category in categories {
                var id: String = category[1] as! String
                var name: String = category[0] as! String
                self.categories.append(YelpBusinessCategory(id: id, name: name, children: []))
            }
        }
    }
}