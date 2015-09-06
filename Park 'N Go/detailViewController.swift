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
    
    var toPass:String!
    var distanceLabelString:String!
    var etaLabelString:String!
    var locationManager = CLLocationManager();
    var routeToUse: MKRoute!
    var coordinateToUse:CLLocationCoordinate2D!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetData:", name: "reloadData", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData:", name: "loadData", object: nil);
        smallMapView.delegate = self;
        locationManager.delegate = self;
        
        pinnedLocationTableView.delegate = self
        pinnedLocationTableView.dataSource = self
        
        smallMapView.mapType = MKMapType.Hybrid;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        smallMapView.zoomEnabled = true;
        if let loadedData = NSUserDefaults.standardUserDefaults().dataForKey("pinnedLocation") {
            if let loadedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? CLLocation {
                println("You've gotten to the detailViewcontroller")
                let location = loadedLocation;
                let coordinate = loadedLocation.coordinate
                self.coordinateToUse = coordinate
                calculateDistanceAndEta(coordinate)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    var title = "";
                    var subtitle = "";
                    var locality = "";
                    if(error == nil) {
                        if let placemark = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                            var subThoroughfare:String = "";
                            var thoroughfare:String = "";
                            var locality:String = "";
                            var postalCode:String = "";
                            var administrativeArea:String = "";
                            var country:String = "";
                            
                            if (placemark.subThoroughfare != nil) {
                                subThoroughfare = placemark.subThoroughfare;
                            }
                            if(placemark.thoroughfare != nil) {
                                thoroughfare = placemark.thoroughfare;
                            }
                            if(placemark.locality != nil) {
                                locality = placemark.locality;
                            }
                            if(placemark.postalCode != nil) {
                                postalCode = placemark.postalCode;
                            }
                            if(placemark.administrativeArea != nil) {
                                administrativeArea = placemark.administrativeArea;
                            }
                            if(placemark.country != nil) {
                                country = placemark.country;
                            }
                            println("viewcontroller placmark data:");
                            println(locality);
                            println(postalCode);
                            println(administrativeArea);
                            println(country);
                            
                            title = " \(subThoroughfare) \(thoroughfare) \n \(locality), \(administrativeArea) \n \(postalCode) \(country)";
                            subtitle = " \(subThoroughfare) \(thoroughfare)";
                            println(title);
                            //                            self.addressLabel.text = title;
                            self.toPass = title
                        }
                    }
                    var latitude = location.coordinate.latitude;
                    var longitude = location.coordinate.longitude;
                    var latDelta:CLLocationDegrees = 0.001;
                    var longDelta:CLLocationDegrees = 0.001;
                    
                    var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
                    var overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
                    var region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
                    var annotation = MKPointAnnotation();
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
    func calculateDistanceAndEta(locationCooridnate: CLLocationCoordinate2D) {
        let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
        let selectedPlacemark = MKPlacemark(coordinate: locationCooridnate, addressDictionary: nil);
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
        let mapItems = [currentLocMapItem, selectedMapItem];
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.transportType = MKDirectionsTransportType.Walking;
        request.setSource(currentLocMapItem)
        request.setDestination(selectedMapItem);
        var directions: MKDirections = MKDirections(request: request);
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if (error == nil) {
                if (response.routes.count > 0) {
                    var route: MKRoute = response.routes[0] as! MKRoute;
                    self.routeToUse = route
                    //                    route.distance = distance
                    //                    route.expectedTravelTime = eta
                    self.distanceFromPinLabel.text = "\(route.distance)"
                    self.etaLabel.text = "\(route.expectedTravelTime)"
                }
            }
        }
    }
    
    func loadData(notification:NSNotification) {
        if let loadedData = NSUserDefaults.standardUserDefaults().dataForKey("pinnedLocation") {
            if let loadedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? CLLocation {
                println("You've gotten to the detailViewcontroller")
                let location = loadedLocation;
                let coordinate = loadedLocation.coordinate
                
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    var title = "";
                    var subtitle = "";
                    var locality = "";
                    if(error == nil) {
                        if let placemark = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                            var subThoroughfare:String = "";
                            var thoroughfare:String = "";
                            var locality:String = "";
                            var postalCode:String = "";
                            var administrativeArea:String = "";
                            var country:String = "";
                            
                            if (placemark.subThoroughfare != nil) {
                                subThoroughfare = placemark.subThoroughfare;
                            }
                            if(placemark.thoroughfare != nil) {
                                thoroughfare = placemark.thoroughfare;
                            }
                            if(placemark.locality != nil) {
                                locality = placemark.locality;
                            }
                            if(placemark.postalCode != nil) {
                                postalCode = placemark.postalCode;
                            }
                            if(placemark.administrativeArea != nil) {
                                administrativeArea = placemark.administrativeArea;
                            }
                            if(placemark.country != nil) {
                                country = placemark.country;
                            }
                            println("viewcontroller placmark data:");
                            println(locality);
                            println(postalCode);
                            println(administrativeArea);
                            println(country);
                            
                            title = " \(subThoroughfare) \(thoroughfare) \n \(locality), \(administrativeArea) \n \(postalCode) \(country)";
                            subtitle = " \(subThoroughfare) \(thoroughfare)";
//                            self.addressLabel.text = title;
                            self.toPass = title
                        }
                    }
                    var latitude = location.coordinate.latitude;
                    var longitude = location.coordinate.longitude;
                    var latDelta:CLLocationDegrees = 0.001;
                    var longDelta:CLLocationDegrees = 0.001;
                    
                    var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
                    var overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
                    var region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
                    var annotation = MKPointAnnotation();
                    annotation.coordinate = coordinate;
//                    locationToUseForAppleMaps = location
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

    func resetData(notification:NSNotification) {
        smallMapView.removeAnnotations(smallMapView.annotations);
        smallMapView.showsUserLocation = true;
        var location = locationManager.location;
        var latitude = location.coordinate.latitude;
        var longitude = location.coordinate.longitude;
        var latDelta:CLLocationDegrees = 0.001;
        var longDelta:CLLocationDegrees = 0.001;
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
        var overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
        var region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
        self.smallMapView.setRegion(region, animated: true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        pinnedLocationTableView.backgroundColor = UIColor.clearColor()
            let cell = tableView.dequeueReusableCellWithIdentifier("PinnedLocationCell", forIndexPath: indexPath) as! PinnedLocationTableViewCell
            cell.OGAddressLabel.text = completeAddressPinned
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
