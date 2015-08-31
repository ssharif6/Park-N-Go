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

    @IBOutlet weak var pinnedLocationTableView: UITableView!
    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var smallMapView: MKMapView!
    
    var toPass:String!
    
    var locationManager = CLLocationManager();
    
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
                            println(title + "TAR TAR");
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
                    locationToUseForAppleMaps = location
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
//        addressLabel.text = "No pinned location!";

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
        let cell = tableView.dequeueReusableCellWithIdentifier("PinnedLocationCell", forIndexPath: indexPath) as! PinnedLocationTableViewCell
        cell.addressLabel.text = completeAddressPinned
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
