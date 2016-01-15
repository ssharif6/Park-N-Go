//
//  ViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/3/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

var distanceLabelStringG: String!
var etaLabelStringG:String!

var carInitialCoordinate:CLLocationCoordinate2D!
var carInitialLocation: CLLocation!
var completeAddress:NSString = "";
var manager = CLLocationManager();

var pinnedLocationGlobal: CLLocation!


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UIAlertViewDelegate, SideBarDelegate {
    
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var pinLocationButton: UIButton!
   
        
    var currentLocation:MKUserLocation!;
    var isPinLocationButtonPressed = false;

    var isEmpty = false;
    let regionRadius: CLLocationDistance = 1000
    
    var sidebar:SideBar = SideBar()
   
    override func viewDidLoad() {

        super.viewDidLoad()
        

    if(NSUserDefaults.standardUserDefaults().objectForKey("pinnedLocation") != nil) {
            pinLocationButton.enabled = false;
        }
        if let loadedData = NSUserDefaults.standardUserDefaults().dataForKey("pinnedLocation") {
            if let loadedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? CLLocation {
                print(loadedLocation.coordinate.latitude)
                print(loadedLocation.coordinate.longitude)
                getLocationInfo(loadedLocation);
            }
        }
        
        map.delegate = self;
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.requestWhenInUseAuthorization();
        manager.startUpdatingLocation();
        self.map.showsUserLocation = true;
        currentLocation = map.userLocation;
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        //
    }
    
    @IBAction func trashButtonSelected(sender: AnyObject) {
        // Remove from NSDefaults
        // Show alertview
        let alertController = UIAlertController(title: "Are you Sure?", message: "Do you wish to delete your pinned Location?", preferredStyle: .ActionSheet);
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (Action) in
            // Cancel
        }
        let deleteButton = UIAlertAction(title: "Delete", style: .Destructive) { (Action) in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("pinnedLocation");
            NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: nil);
            self.map.removeAnnotations(self.map.annotations);
            self.pinLocationButton.enabled = true;
        }
        alertController.addAction(deleteButton);
        alertController.addAction(cancelAction);
        self.presentViewController(alertController, animated: true, completion: nil);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Find location of user
        let userLocation:CLLocation = locations[0] ;
        userLocationCoordinate = userLocation.coordinate
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location:MKUserLocation = currentLocation;
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location.coordinate, span)
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        carInitialLocation = userLocation;
        carInitialCoordinate = coordinate;
        
        self.map.setRegion(region, animated: true);
    }
    
    @IBAction func pinLocationButton(sender: AnyObject) {
        // add location to the array, so it can be retrieved and put it into temporary storage
        //places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
        isPinLocationButtonPressed = true;
        pinLocationButton.enabled = false;

        getLocationInfo(map.userLocation.location!);
        let pinnedLocation = map.userLocation.location;
        locationToUseForAppleMaps = pinnedLocation
        let locationData = NSKeyedArchiver.archivedDataWithRootObject(pinnedLocation!);
        NSUserDefaults.standardUserDefaults().setObject(locationData, forKey: "pinnedLocation");
        NSNotificationCenter.defaultCenter().postNotificationName("loadData", object: nil);

    }
    func getLocationInfo(locationParameter:CLLocation) {
        
        var location = locationParameter
        var coordinate = location.coordinate
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var title = ""
            if (error == nil) {
                if let p = placemarks?[0] {
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var locality: String = ""
                    var postalCode: String = ""
                    var administrativeArea: String = ""
                    var country: String = ""
                    
                    if p.subThoroughfare != nil {
                        
                        subThoroughfare = p.subThoroughfare!
                    }
                    if p.thoroughfare != nil {
                        
                        thoroughfare = p.thoroughfare! + ","
                        
                    }
                    if(p.locality != nil) {
                        locality = p.locality! + ",";
                    }
                    if(p.postalCode != nil) {
                        postalCode = p.postalCode!;
                    }
                    if(p.administrativeArea != nil) {
                        administrativeArea = p.administrativeArea! + ",";
                    }
                    if(p.country != nil) {
                        country = p.country!;
                    }

                    
                    completeAddress = self.displayLocationInfo(p);
                    title = " \(subThoroughfare) \(thoroughfare) \(locality) \(administrativeArea) \(postalCode) \(country)";
                    completeAddressPinned = title
                }
            }
            // annotation, i.e pins
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = title
            self.map.addAnnotation(annotation)
        })
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription);
    }
    
    func displayLocationInfo(placemark: CLPlacemark) -> String{
        //self.manager.stopUpdatingLocation();
        print(placemark.subThoroughfare);
        print(placemark.thoroughfare);
        print(placemark.locality);
        print(placemark.postalCode);
        print(placemark.administrativeArea);
        print(placemark.country);
        let title = "\(placemark.locality) \(placemark.postalCode) \(placemark.administrativeArea) \(placemark.country)";
        return title;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailViewSegue") {
            let svc = segue.destinationViewController as! detailViewController;
            svc.toPass = title;
        } else if segue.identifier == "pinnedLocationSegue" {
            if let ivc = segue.destinationViewController as? detailViewController {
                ivc.toPass = title;
            }
        }
    }
    
    
}

