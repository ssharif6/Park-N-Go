//
//  Resturant.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/31/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit
import Parse

var resultQueryDictionary:NSDictionary!
var businessArray:NSArray!

class Resturant: NSObject {
    var name: String!
    var thumbUrl: String!
    var address: String!
    var jsonData: NSData!
    var locationDict: NSDictionary        // location
    var sortFromSettings: Int! = 0
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.thumbUrl = dictionary["thumbUrl"] as? String
        self.address = dictionary["address"] as? String
        self.locationDict = dictionary["location"] as? NSDictionary ?? [:]
    }
    
    class func searchWithQuery(map: MKMapView, query: String, completion: ([Resturant]!, NSError!) -> Void) {
//        var radiusInMiles: Double = Double(radiusGlobal) * 0.000621371
        
        let radiusInMeters: Double = Double(radiusGlobal) * 1609.34
        YelpClient.sharedInstance.searchWithTerm(query, sort: sortGlobal, radius: radiusInMeters, limit: numResultsGlobal, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseInfo = response as! NSDictionary
            resultQueryDictionary = responseInfo
            print(responseInfo)
            let dataArray = responseInfo["businesses"] as! NSArray
            businessArray = dataArray
            let businessQuery = PFQuery(className: "Business")
            businessQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                for object in objects! {
                    object.deleteInBackground()
                }
            })
            for business in dataArray {
                let obj = business as! NSDictionary
                let yelpBusinessMock: Business = Business(dictionary: obj)
                
                let businessToParse = PFObject(className: "Business")
                businessToParse["name"] = yelpBusinessMock.name
                businessToParse["address"] = yelpBusinessMock.address
                businessToParse["categories"] = yelpBusinessMock.categories
                businessToParse["distance"] = yelpBusinessMock.distance
                businessToParse["imageURLString"] = yelpBusinessMock.imageURLString
                businessToParse.saveInBackgroundWithBlock({ (sucessful: Bool, errors: NSError?) -> Void in
                    if(sucessful) {
                        
                    } else {
                       print(errors?.description)
                    }
                })
                let annotation = MKPointAnnotation()
                annotation.coordinate = yelpBusinessMock.location.coordinate
                annotation.title = yelpBusinessMock.name
                annotation.subtitle = yelpBusinessMock.displayAddress
                map.addAnnotation(annotation)
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
         print(error)
        }
    }
    
    // term: String, deal: Bool, radius: Int, sort: Int, categories: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {

    class func searchWithQueryWithRadius(map: MKMapView, term: String, deal: Bool, radius: Int, sort: Int, categories: String, completion: ([Resturant]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, deal: false, radius: radius, sort: sort,categories: categories, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseInfo = response as! NSDictionary
            resultQueryDictionary = responseInfo
            print(responseInfo)
            let dataArray = responseInfo["businesses"] as! NSArray
            for business in dataArray {
                let obj = business as! NSDictionary
                let yelpBusinessMock: YelpBusiness = YelpBusiness(dictionary: obj)
                let annotation = MKPointAnnotation()
                annotation.coordinate = yelpBusinessMock.location.coordinate
                annotation.title = yelpBusinessMock.name
                map.addAnnotation(annotation)
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print(error)
        }
    }
    
}
