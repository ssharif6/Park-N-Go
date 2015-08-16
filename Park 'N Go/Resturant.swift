//
//  Resturant.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/31/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit
var resultQueryDictionary:NSDictionary!

class Resturant: NSObject {
    var name: String!
    var thumbUrl: String!
    var address: String!
    var jsonData: NSData!
    var location: NSDictionary        // location

    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        thumbUrl = dictionary["thumbUrl"] as? String
        address = dictionary["address"] as? String
        self.location = dictionary["location"] as? NSDictionary ?? [:]
    }
    
    class func searchWithQuery(map: MKMapView, query: String, completion: ([Resturant]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(query,sort: 0, radius: 1069, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseInfo = response as! NSDictionary
            resultQueryDictionary = responseInfo
            println(responseInfo)
            let dataArray = responseInfo["businesses"] as! NSArray
            for business in dataArray {
                let obj = business as! NSDictionary
                var yelpBusinessMock: YelpBusiness = YelpBusiness(dictionary: obj)
                var annotation = MKPointAnnotation()
                annotation.coordinate = yelpBusinessMock.location.coordinate
                annotation.title = yelpBusinessMock.name
                annotation.subtitle = yelpBusinessMock.displayAddress
                map.addAnnotation(annotation)
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
         println(error)
        }
    }
    // term: String, deal: Bool, radius: Int, sort: Int, categories: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {

    class func searchWithQueryWithRadius(map: MKMapView, term: String, deal: Bool, radius: Int, sort: Int, categories: String, completion: ([Resturant]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, deal: false, radius: radius, sort: sort,categories: categories, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseInfo = response as! NSDictionary
            resultQueryDictionary = responseInfo
            println(responseInfo)
            let dataArray = responseInfo["businesses"] as! NSArray
            for business in dataArray {
                let obj = business as! NSDictionary
                var yelpBusinessMock: YelpBusiness = YelpBusiness(dictionary: obj)
                var annotation = MKPointAnnotation()
                annotation.coordinate = yelpBusinessMock.location.coordinate
                annotation.title = yelpBusinessMock.name
                map.addAnnotation(annotation)
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    }
    
}
