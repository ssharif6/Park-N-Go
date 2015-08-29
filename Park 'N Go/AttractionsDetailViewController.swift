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

    @IBAction func goToAddressButton(sender: AnyObject) {
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
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if(annotation is MKUserLocation) {
//            return nil;
//        }
//        let reuseId = "pin";
//        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView;
//        if(pinView == nil) {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId);
//            pinView!.canShowCallout = true;
//            pinView!.animatesDrop = true;
//        }
//        var rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton; // change this to custom after graphic is made
//        pinView?.rightCalloutAccessoryView = rightButton;
//        return pinView;
//    }
//    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
//        let selectedLocation = view.annotation;
//        attractionLocation = selectedLocation.coordinate;
//        if(control == view.rightCalloutAccessoryView) {
//            let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
//            let selectedPlacemark = MKPlacemark(coordinate: selectedLocation.coordinate, addressDictionary: nil);
//            let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
//            let mapItems = [currentLocMapItem, selectedMapItem];
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking];
//            
//            MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions);
//        }
//    }
    func getDataFromYelp() {
        YelpInfoTableview.dataSource = self
        YelpInfoTableview.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var businessMock: Business = Business(dictionary: currentBusiness)

        if indexPath.row == 0 {
            let directionsCell = YelpInfoTableview.dequeueReusableCellWithIdentifier("YelpInfoDirectionCell", forIndexPath: indexPath) as! YelpInfoDirectionCell
//            directionsCell.business = currentBusiness
            directionsCell.business = businessMock
            
            return directionsCell
            
        } else if indexPath.row == 1 {
            let contactCell = YelpInfoTableview.dequeueReusableCellWithIdentifier("YelpInfoContactCell", forIndexPath: indexPath) as! YelpInfoContactCell
            contactCell.business = businessMock
            return contactCell
            
        } else {
            let infoCell = YelpInfoTableview.dequeueReusableCellWithIdentifier("YelpInfoInfoCell", forIndexPath: indexPath) as! YelpInfoInfoCell
            infoCell.business = businessMock
            return infoCell
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
