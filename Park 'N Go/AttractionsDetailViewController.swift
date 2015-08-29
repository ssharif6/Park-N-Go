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


class AttractionsDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var detailMap: MKMapView!
    
    var attractionDetailAddressString:String!

    var pinnedAttraction:CLLocation! // given the coordinate
    
    var locationManager:CLLocationManager = CLLocationManager();
    
    var attractionLocation:CLLocationCoordinate2D!;
    
    var attractionLocationDetail: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.font = UIFont(name: addressLabel.font.fontName, size: 18);
        detailMap.delegate = self;
        locationManager.delegate = self;
        detailMap.mapType = MKMapType.Hybrid;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        detailMap.zoomEnabled = true;
//        getYelpData()
        getDataFromYelp()
        // Do any additional setup after loading the view.
    }

    @IBAction func goToAddressButton(sender: AnyObject) {
        let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
        let selectedPlacemark = MKPlacemark(coordinate: attractionLocation, addressDictionary: nil);
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
        let mapItems = [currentLocMapItem, selectedMapItem];
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking];
        
        MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions);

    }
    func getInfo() {
        var latitude = attractionLocation.latitude;
        var longitude  = attractionLocation.longitude;
        var latDelta:CLLocationDegrees = 0.000001
        var longDelta: CLLocationDegrees = 0.000001
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
        var location = CLLocationCoordinate2DMake(latitude, longitude);
        var realLocation = CLLocation(latitude: latitude, longitude: longitude);
        CLGeocoder().reverseGeocodeLocation(realLocation, completionHandler: { (placemarks, error) -> Void in
            var title = ""
            var subtitle = ""
            var locality = ""
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
                    
                    title = " \(subThoroughfare) \(thoroughfare) \n \(locality), \(administrativeArea) \n \(postalCode)\(country)";
                    subtitle = " \(subThoroughfare) \(thoroughfare)";
                    println(title);
                    self.addressLabel.text = title;
                    
                }
            }
            var overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
            var region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
            var annotation = MKPointAnnotation();
            annotation.coordinate = location;
            annotation.title = subtitle;
            self.detailMap.addAnnotation(annotation);
            self.detailMap.setRegion(region, animated: true)
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if(annotation is MKUserLocation) {
            return nil;
        }
        let reuseId = "pin";
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView;
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId);
            pinView!.canShowCallout = true;
            pinView!.animatesDrop = true;
        }
        var rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton; // change this to custom after graphic is made
        pinView?.rightCalloutAccessoryView = rightButton;
        return pinView;
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let selectedLocation = view.annotation;
        attractionLocation = selectedLocation.coordinate;
        if(control == view.rightCalloutAccessoryView) {
            let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
            let selectedPlacemark = MKPlacemark(coordinate: selectedLocation.coordinate, addressDictionary: nil);
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
            let mapItems = [currentLocMapItem, selectedMapItem];
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking];
            
            MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions);
        }
    }
    func getDataFromYelp() {
        var businessMock:Resturant = Resturant(dictionary: resultQueryDictionary)
        self.addressLabel.text = self.attractionDetailAddressString
    }

//    func getYelpData() {
//        var businessMock:Resturant = Resturant(dictionary: resultQueryDictionary)
////        attractionDetailAddressString = resultQueryDictionary["display_address"] as? String;
//        self.addressLabel.text = attractionDetailAddressString
//        //        var yelpBusiness:Resturat = YelpBusiness(dictionary: resultQueryDictionary)
////        var displayAddress = yelpBusiness.displayAddress
////        println(displayAddress + "display address ")
////        var displayCategories = yelpBusiness.displayCategories
////        var imageURL = yelpBusiness.imageURL
////        var latitude = yelpBusiness.latitude
////        var longitude = yelpBusiness.longitude
////        var name = yelpBusiness.name as String
////        var phoneNumber = yelpBusiness.phone as String
////        var rating = yelpBusiness.rating as String
////        var ratingImageURL = yelpBusiness.ratingImageURL as NSURL
////        var reviewCount = yelpBusiness.reviewCount as Int
////        var shortAddress = yelpBusiness.shortAddress as String
//    }
    
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
