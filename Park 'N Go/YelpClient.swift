//
//  YelpClient.swift
//  Yelp
//
//  Created by Jerry Su on 9/19/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

let yelpConsumerKey = "KLGHOrMdpCJd7RB6LfnmhQ"
let yelpConsumerSecret = "wPmTdEc5r9S1TDPVuaj6o0eTvOA"
let yelpToken = "0-3Dshnqym6h_51BISJ3IFREyhcWHhAq"
let yelpTokenSecret = "BViEik1zmcGFOCSuiXmwB0UC9KQ"

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, sort: Int, radius: Double, limit: Int, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
//        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        let parameters = ["term": term, "ll": "\(userLocationCoordinate.latitude), \(userLocationCoordinate.longitude)", "sort": sort, "radius_filter": radius, "limit": limit]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
    func searchWithTerm(term: String, deal: Bool, radius: Int, sort: Int, categories: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = NSDictionary()
        if (radius == -1) {
            parameters = ["term": term, "ll": "\(userLocationCoordinate.latitude), \(userLocationCoordinate.longitude)", "deals_filter": deal, "sort": sort, "category_filter": categories]
        }
        else {
            let meter:Double = Double(radius) * 1609.34
            parameters = ["term": term, "ll": "\(userLocationCoordinate.latitude), \(userLocationCoordinate.longitude)", "deals_filter": deal, "radius_filter": meter, "sort": sort, "category_filter": categories]
        }
        return self.GET("search", parameters: parameters as [NSObject : AnyObject], success: success, failure: failure)
    }
    
    
}