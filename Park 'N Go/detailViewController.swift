//
//  detailViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/7/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit

var completeAddressPinned: String!
var locationToUseForAppleMaps: CLLocation!

class detailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceFromPinLabel: UILabel!
    @IBOutlet weak var pinnedLocationTableView: UITableView!
    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var smallMapView: MKMapView!
    var cachedMessage : String? = nil
    var toPass:String!
    var distanceLabelString:String!
    var etaLabelString:String!
    var locationManager = CLLocationManager();
    var routeToUse: MKRoute!
    var coordinateToUse:CLLocationCoordinate2D!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData:", name: "reloadData", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData:", name: "loadData", object: nil);
        // When pin is deleted
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pinDeleted:", name: "pinDeleted", object: nil)

        smallMapView.delegate = self;
        locationManager.delegate = self;
        self.pinnedLocationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        pinnedLocationTableView.scrollEnabled = false
        
        pinnedLocationTableView.delegate = self
        pinnedLocationTableView.dataSource = self
        
        smallMapView.mapType = MKMapType.Hybrid;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        smallMapView.zoomEnabled = true;
        if let loadedData = NSUserDefaults.standardUserDefaults().dataForKey("pinnedLocation") {
            if let loadedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? CLLocation {
                print("You've gotten to the detailViewcontroller")
                let location = loadedLocation;
                let coordinate = loadedLocation.coordinate
                self.coordinateToUse = coordinate
                calculateDistanceAndEta(coordinate)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    var title = "";
                    var subtitle = "";
                    if(error == nil) {
                        if let placemark = placemarks?[0] {
                            var subThoroughfare:String = "";
                            var thoroughfare:String = "";
                            var locality:String = "";
                            var postalCode:String = "";
                            var administrativeArea:String = "";
                            var country:String = "";
                            
                            if (placemark.subThoroughfare != nil) {
                                subThoroughfare = placemark.subThoroughfare!;
                            }
                            if(placemark.thoroughfare != nil) {
                                thoroughfare = placemark.thoroughfare!;
                            }
                            if(placemark.locality != nil) {
                                locality = placemark.locality!;
                            }
                            if(placemark.postalCode != nil) {
                                postalCode = placemark.postalCode!;
                            }
                            if(placemark.administrativeArea != nil) {
                                administrativeArea = placemark.administrativeArea!;
                            }
                            if(placemark.country != nil) {
                                country = placemark.country!;
                            }
                            print("viewcontroller placmark data:");
                            print(locality);
                            print(postalCode);
                            print(administrativeArea);
                            print(country);
                            
                            title = " \(subThoroughfare) \(thoroughfare) \n \(locality), \(administrativeArea) \n \(postalCode) \(country)";
                            subtitle = " \(subThoroughfare) \(thoroughfare)";
                            print(title);
                            //                            self.addressLabel.text = title;
                            self.toPass = title
                        }
                    }
                    let latitude = location.coordinate.latitude;
                    let longitude = location.coordinate.longitude;
                    let latDelta:CLLocationDegrees = 0.001;
                    let longDelta:CLLocationDegrees = 0.001;
                    
                    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
                    let overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
                    let annotation = MKPointAnnotation();
                    locationToUseForAppleMaps = location
                    annotation.coordinate = coordinate;
                    annotation.title = subtitle;
                    self.smallMapView.addAnnotation(annotation);
                    self.smallMapView.setRegion(region, animated: true)
                    
                })
                
            }
        }
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        calculateDistanceAndEta(coordinateToUse)
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if minutes < 60 {
            if minutes < 10 {
                return String(format: "%2d:%02d", minutes, seconds)
            } else {
                return String(format: "%02d:%02d", minutes, seconds)
            }
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func calculateDistanceAndEta(locationCooridnate: CLLocationCoordinate2D) {
        let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
        let selectedPlacemark = MKPlacemark(coordinate: locationCooridnate, addressDictionary: nil);
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.transportType = MKDirectionsTransportType.Walking;
        request.source = currentLocMapItem
        request.destination = selectedMapItem
        let directions: MKDirections = MKDirections(request: request);
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if (error == nil) {
                if (response!.routes.count > 0) {
                    let route: MKRoute = response!.routes[0] ;
                    self.routeToUse = route
                    //                    route.distance = distance
                    //                    route.expectedTravelTime = eta
                    let distanceInMiles = route.distance * 0.000621371192237
                    let distanceInMilesRounded = Double(round(100 * distanceInMiles)/100)
                    self.distanceFromPinLabel.text = "\(distanceInMilesRounded) Miles"
                    let minutesAndHourtext = self.stringFromTimeInterval(route.expectedTravelTime)
                    self.etaLabel.text = "\(minutesAndHourtext)"
                }
            }
        }
    }
    
    func loadData(notification:NSNotification) {
        if let loadedData = NSUserDefaults.standardUserDefaults().dataForKey("pinnedLocation") {
            if let loadedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? CLLocation {
                print("You've gotten to the detailViewcontroller")
                let location = loadedLocation;
                let coordinate = loadedLocation.coordinate
                
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    var title = "";
                    var subtitle = "";
                    if(error == nil) {
                        if let placemark = placemarks?[0] {
                            var subThoroughfare:String = "";
                            var thoroughfare:String = "";
                            var locality:String = "";
                            var postalCode:String = "";
                            var administrativeArea:String = "";
                            var country:String = "";
                            if (placemark.subThoroughfare != nil) {
                                subThoroughfare = placemark.subThoroughfare!;
                            }
                            if(placemark.thoroughfare != nil) {
                                thoroughfare = placemark.thoroughfare!;
                            }
                            if(placemark.locality != nil) {
                                locality = placemark.locality!;
                            }
                            if(placemark.postalCode != nil) {
                                postalCode = placemark.postalCode!;
                            }
                            if(placemark.administrativeArea != nil) {
                                administrativeArea = placemark.administrativeArea!;
                            }
                            if(placemark.country != nil) {
                                country = placemark.country!;
                            }
                            print("viewcontroller placmark data:");
                            print(locality);
                            print(postalCode);
                            print(administrativeArea);
                            print(country);
                            
                            title = " \(subThoroughfare) \(thoroughfare) \n \(locality), \(administrativeArea) \n \(postalCode) \(country)";
                            subtitle = " \(subThoroughfare) \(thoroughfare)";
//                            self.addressLabel.text = title;
                            self.toPass = title
                        }
                    }
                    let latitude = location.coordinate.latitude;
                    let longitude = location.coordinate.longitude;
                    let latDelta:CLLocationDegrees = 0.001;
                    let longDelta:CLLocationDegrees = 0.001;
                    
                    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
                    let overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
                    let annotation = MKPointAnnotation();
                    annotation.coordinate = coordinate;
                    annotation.title = subtitle;
                    self.smallMapView.addAnnotation(annotation);
                    self.smallMapView.setRegion(region, animated: true)
                    
                })
                
            }
        }

    }

    func goToAddressButton(sender: AnyObject) {
        let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
        let selectedPlacemark = MKPlacemark(coordinate: locationToUseForAppleMaps.coordinate, addressDictionary: nil);
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
        let mapItems = [currentLocMapItem, selectedMapItem];
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking];
        MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions);
    }

    func reloadData(notification:NSNotification) {
        smallMapView.removeAnnotations(smallMapView.annotations);
        smallMapView.showsUserLocation = true;
        let location = locationManager.location;
        let latitude = location!.coordinate.latitude;
        let longitude = location!.coordinate.longitude;
        let latDelta:CLLocationDegrees = 0.001;
        let longDelta:CLLocationDegrees = 0.001;
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
        let overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
        self.smallMapView.setRegion(region, animated: true)
        pinnedLocationTableView.reloadInputViews()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        pinnedLocationTableView.backgroundColor = UIColor.clearColor()
            let cell = tableView.dequeueReusableCellWithIdentifier("PinnedLocationCell", forIndexPath: indexPath) as! PinnedLocationTableViewCell
            cell.OGAddressLabel.text = completeAddressPinned
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            goToAddressButton(self)
        }
    }
}
