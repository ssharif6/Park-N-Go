//
//  Business.swift
//  Yelp
//
//  Created by Jerry Su on 9/20/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import CoreLocation

class YelpBusiness {

    var dictionary: NSDictionary
    

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    var business: String {
        get {
            return self.dictionary["businesses"] as! String
        }
    }

    var name: String {
        get {
            return self.dictionary["name"] as! String
        }
    }
    
    var phone: String {
        get {
            return self.dictionary["phone"] as! String
        }
    }
    
    var rating: String {
        get {
            return self.dictionary["rating"] as! String
        }
    }

    var imageURL: NSURL? {
        get {
            if let image = self.dictionary["image_url"] as? String {
//                return NSURL(string: image.stringByReplacingOccurrencesOfString("ms.jpg", withString: "ls.jpg", options: nil, range: nil))
                return NSURL(string: image.stringByReplacingOccurrencesOfString("ms.jpg", withString: "ls.jpg"))
            }
            return nil
        }
    }

    var ratingImageURL: NSURL {
        get {
            return NSURL(string: self.dictionary["rating_img_url_large"] as! String)!
        }
    }

    var reviewCount: Int {
        get {
            return self.dictionary["review_count"] as! Int
        }
    }

    var deals: Array<AnyObject>? {
        get {
            if let deals = self.dictionary["deals"] as? Array<AnyObject> {
                return deals
            }
            return nil
        }
    }

    var latitude: Double? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["latitude"] as! Double)
                }
            }
            return nil
        }
    }

    var longitude: Double? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["longitude"] as! Double)
                }
            }
            return nil
        }
    }

    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        }
    }

    var shortAddress: String {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let address = location["address"] as? Array<String> {
                    if let neighborhoods = location["neighborhoods"] as? Array<String> {
//                        return ", ".join(address + [neighborhoods[0]])
                        let neighborhoodAddress = neighborhoods + address
                        return neighborhoodAddress.joinWithSeparator(", ")
                    }
                    
                }
            }
            return ""
        }
    }

    var displayAddress: String {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let address = location["display_address"] as? Array<String> {
                    return address.joinWithSeparator(", ")
                }
            }
            return ""
        }
    }

    var displayCategories: String {
        get {
            if let categories = self.dictionary["categories"] as? Array<Array<String>> {
                return categories.map({ $0[0] }).joinWithSeparator(", ")
            }
            return ""
        }
    }
    
    

}