//
//  detailViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/7/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit


class detailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate {

    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var smallMapView: MKMapView!
    
    var toPass:String!
    var locationManager = CLLocationManager();
    
    @IBOutlet weak var PinnedCategories: UITableViewCell!
    
    var cat = ["Petrol", "Hospital", "Mechanic"]
    
    @IBOutlet var addressLabel: UILabel!
    override func viewDidLoad() {

        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetData:", name: "reloadData", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData:", name: "loadData", object: nil);
        addressLabel.font = UIFont(name: addressLabel.font.fontName, size: 18)
        smallMapView.delegate = self;
        locationManager.delegate = self;
        smallMapView.mapType = MKMapType.Hybrid;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        smallMapView.zoomEnabled = true;
        smallMapView.rotateEnabled = true;

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
                            self.addressLabel.text = title;
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
                            println(title);
                            self.addressLabel.text = title;
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
                    annotation.title = subtitle;
                    self.smallMapView.addAnnotation(annotation);
                    self.smallMapView.setRegion(region, animated: true)
                    
                })
                
            }
        }

    }
    func resetData(notification:NSNotification) {
        smallMapView.removeAnnotations(smallMapView.annotations);
        smallMapView.showsUserLocation = true;
        addressLabel.text = "No pinned location!";
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
        return cat.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = cat[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
