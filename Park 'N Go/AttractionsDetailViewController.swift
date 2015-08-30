//
//  AttractionsDetailViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/10/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit
import AddressBook


class AttractionsDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var detailMap: MKMapView!
    
    var attractionDetailAddressString:String!
    var currentBusiness:NSDictionary!

    var businessToUse: Business!
    
    var pinnedAttraction:CLLocation! // given the coordinate
    
    var locationManager:CLLocationManager = CLLocationManager();
    
    var attractionLocation:CLLocationCoordinate2D!;
    
    var attractionLocationDetail: NSDictionary!
    // Outlets
    @IBOutlet weak var YelpInfoTableview: UITableView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadYelpInfo()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        getDataFromYelp()
    }

    func goToAddressButton(sender: AnyObject) {
        let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
        let selectedPlacemark = MKPlacemark(coordinate: attractionLocation, addressDictionary: nil);
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
        let mapItems = [currentLocMapItem, selectedMapItem];
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking];
        
        MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions);

    }
    func loadYelpInfo() {
        businessName.text = businessToUse.name
        let thumbImageViewData = NSData(contentsOfURL: businessToUse.imageURL!)
        thumbImage.image = UIImage(data: thumbImageViewData!)
        let reviewImageData = NSData(contentsOfURL: businessToUse.ratingImageURL!)
        reviewImage.image = UIImage(data: reviewImageData!)
        categories.text = businessToUse.categories
        reviews.text = "\(businessToUse.reviewCount!) Reviews"
        distanceLabel.text = businessToUse.distance
    }
    
    func getDataFromYelp() {
        YelpInfoTableview.dataSource = self
        YelpInfoTableview.delegate = self
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        tableView.rowHeight = 100
        return tableView.rowHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of cells
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var businessMock: Business = Business(dictionary: currentBusiness)

        if indexPath.row == 0 { // Direction Cell
            let directionsCell = YelpInfoTableview.dequeueReusableCellWithIdentifier("YelpInfoDirectionCell", forIndexPath: indexPath) as! YelpInfoDirectionCell
            directionsCell.business = businessMock
            return directionsCell
            
        } else if indexPath.row == 1 { // Contact Cell
            let contactCell = YelpInfoTableview.dequeueReusableCellWithIdentifier("YelpInfoContactCell", forIndexPath: indexPath) as! YelpInfoContactCell
            contactCell.business = businessMock
            return contactCell
            
        } else { // MoreInfo Cell
            let infoCell = YelpInfoTableview.dequeueReusableCellWithIdentifier("YelpInfoInfoCell", forIndexPath: indexPath) as! YelpInfoInfoCell
            infoCell.business = businessMock
            return infoCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            goToAddressButton(self)
        } else if indexPath.row == 1 {
            makeCall()
        } else {
            openYelpURL()
        }
    }
    
    func makeCall() {
        var url: NSURL = NSURL(string: "tel://" + businessToUse.phone)!
        UIApplication.sharedApplication().openURL(url)
        // Doesn't work on simulator
    }
    
    func openYelpURL() {
        if let checkURL = NSURL(string: businessToUse.mobileUrl) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                println("url opened sucesfully")
            }
        } else {
            println("url failed")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
