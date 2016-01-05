//
//  AttractionsVC.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/10/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

var userLocationCoordinate:CLLocationCoordinate2D!;

class AttractionsVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UINavigationControllerDelegate, SideBarDelegate {
    
    @IBOutlet weak var yelpTableButton: UIBarButtonItem!
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var searchBar2: UISearchBar!

    @IBOutlet weak var searchButton: UIBarButtonItem!
    var businessMock: Business!
    var matchingItems: [MKMapItem] = [MKMapItem]();
    var indicatedMapItem:CLLocationCoordinate2D!;
    var attractionLocationString:String!
    // For list in pinned location and attractions. To be
    var attractionDict: NSDictionary!
    var categoryDictionary = [String:[String]]();
    

    @IBOutlet var searchText: UITextField!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var attractionsMap: MKMapView!
    var locationManager = CLLocationManager();
    var businessStreetAddress: CLLocationCoordinate2D!
    var tempSearchBar:UIBarButtonItem!


    @IBOutlet weak var openSidebar: UIBarButtonItem!
    @IBOutlet weak var attractionsTabView: UITableView! //testVersion
    @IBOutlet weak var AttractionsTableView: UITableView!
    
    var currentArray:[String] = [String]();
    var categoriesList = ["Food", "Entertainment", "Recreation", "Shopping", "Transport", "Lodging", "Services"]
    var foodCategories = [String]();
    var entertainmentCategories = [String]();
    var recreationCategories = [String]();
    var shoppingCategories = [String]();
    var transportCategories = [String]();
    var lodgingCategories = [String]();
    var servicesCategories = [String]();
    var queryString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        searchBar2.delegate = self
        searchBar2.searchBarStyle = UISearchBarStyle.Minimal
        setupSetUps();
        attractionsMap.mapType = MKMapType.Hybrid;
        attractionsMap.delegate = self;
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Do any additional setup after loading the view.
        let location = self.locationManager.location;
        let latitude = location!.coordinate.latitude;
        let longitude = location!.coordinate.longitude;
        let latDelta:CLLocationDegrees = 0.03;
        let longDelta:CLLocationDegrees = 0.03;
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
        let overallLoc = CLLocationCoordinate2DMake(latitude, longitude);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(overallLoc, span);
        attractionsMap.region = region;
        attractionsMap.setRegion(region, animated: true)
        self.attractionsMap.showsUserLocation = true;
        // Set Notification Observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sortBySettingsChanged:", name: "sortBySettingsChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "radiusSettingsChanged:", name: "radiusSettingsChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "numResultsPickerChanged:", name: "numResultsPickerChanged", object: nil)
    }
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
    }
    func sidebarDidSelectButtonAtIndex(index: Int) {
    
    }
    func numResultsPickerChanged(notification: NSNotification) {
        performYelpSearch(queryString)
    }
    func radiusSettingsChanged (notification: NSNotification) {
        performYelpSearch(queryString)
    }
    func sortBySettingsChanged (notification: NSNotification) {
        performYelpSearch(queryString)
    }
    func searchbarPopulate() {
        tempSearchBar = searchButton
        searchBar2.delegate = self
        searchBar2.searchBarStyle = UISearchBarStyle.Minimal
        searchBar2.showsCancelButton = true
    }
    
    @IBAction func settingsButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("attractionsToSettings", sender: self)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
        attractionsMap.removeAnnotations(attractionsMap.annotations);
        performYelpSearch(searchBar.text!)
    }

    func setupSetUps() {
        
        setUpCategoryEntertainment()
        setupCategoryFood();
        setUpRecreation()
        setUpShopping()
        setUpTransport()
        setUpLodging()
        setupServices()
        
    }
    
    func setupCategoryFood() {
        let asianFood = "Asian Food"
        let americanFood = "American Food"
        let bakery = "Bakery"
        let cofeehouses = "Coffee"
        let seafood = "Seafood"
        let steakhouses = "Steakhouse"
        let mexicanFood = "Mexican Food"
        let fastFood = "Fast Food"
        let MiddleEasternFood = "Middle Eastern Food"
        
        foodCategories.append(asianFood);
        foodCategories.append(mexicanFood);
        foodCategories.append(fastFood);
        foodCategories.append(MiddleEasternFood);
        foodCategories.append(americanFood);
        foodCategories.append(bakery);
        foodCategories.append(cofeehouses);
        foodCategories.append(seafood);
        foodCategories.append(steakhouses);

        
        categoryDictionary["Food"] = foodCategories;
    }
    func setUpCategoryEntertainment() {
        let movieTheaters = "Movie Theatre"

        entertainmentCategories.append(movieTheaters);
        
        categoryDictionary["Entertainment"] = entertainmentCategories;

    }
    func setUpRecreation() {
        let parks = "Parks"
        let beaches = "Beach"
        let amusementParks = "Amusement Park"
        
        recreationCategories.append(parks);
        recreationCategories.append(beaches);
        recreationCategories.append(amusementParks);
        
        categoryDictionary["Recreation"] = recreationCategories;

    }
    func setUpShopping() {
        let malls = "Mall";
        shoppingCategories.append(malls);
        let supermarkets = "Supermarket";
        let electronics = "Electronics";
        
        shoppingCategories.append(malls);
        shoppingCategories.append(supermarkets);
        shoppingCategories.append(electronics);
        
        categoryDictionary["Shopping"] = shoppingCategories;
    }
    func setUpTransport() {
        let busStops = "Bus Stops"
        let parknride = "Park & Ride"
        let taxis = "Taxi"
        
        transportCategories.append(busStops);
        transportCategories.append(parknride);
        transportCategories.append(taxis);
        
        categoryDictionary["Transport"] = transportCategories;

    }
    func setUpLodging() {
        let hotels = "Hotel"
        let motels = "Motel"
        let hostels = "Hostel"
        
        lodgingCategories.append(hotels);
        lodgingCategories.append(motels);
        lodgingCategories.append(hostels);
        
        categoryDictionary["Lodging"] = lodgingCategories;
    }
    func setupServices() {
        let bank = "Bank"
        let atm = "ATM"
        let postOffice = "Post Office"
        
        servicesCategories.append(bank);
        servicesCategories.append(atm);
        servicesCategories.append(postOffice);
        
        categoryDictionary["Services"] = servicesCategories;
    }

    func performYelpSearch(query: String) {
        queryString = query
        attractionsMap.removeAnnotations(attractionsMap.annotations)
        matchingItems.removeAll()

        Resturant.searchWithQuery(self.attractionsMap, query: query, completion: { (BusinessList: [Resturant]!, error: NSError!) in
            if(error != nil) {
                print("Error occured in search: \(error.localizedDescription)")
            } else if BusinessList.count == 0 {
                print("No matches found")
            } else {
                print("Yelp matches found!")
            }
        })
    }
    
    func performYelpSearchWithParams(query: String) {
        attractionsMap.removeAnnotations(attractionsMap.annotations)
        matchingItems.removeAll()
        var resturantMock:Resturant = Resturant(dictionary: resultQueryDictionary)
        Resturant.searchWithQueryWithRadius(self.attractionsMap, term: query, deal: false, radius: 100, sort: 0, categories: "Restaurants") { (BusinessList: [Resturant]!, error: NSError!) -> Void in
            if(error != nil) {
                print("Error occured in the search \(error.localizedDescription)")
            } else if BusinessList.count == 0 {
                print("No matches")
            } else {
                print("Yelp Matches Found!")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude);
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.01, 0.01));
        self.attractionsMap.setRegion(region, animated: true);
        
        let point:MKPointAnnotation! = MKPointAnnotation();
        point.coordinate = location!.coordinate;
        point.title = "Current Location";
        point.subtitle = "Subtitle";
        self.attractionsMap.addAnnotation(point);
        locationManager.stopUpdatingLocation();
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation) {
            return nil;
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView;
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId);
            pinView!.canShowCallout = true;
            pinView!.animatesDrop = true;
            
        }
        let moreInfoButton = UIButton(type: UIButtonType.DetailDisclosure)
        pinView?.rightCalloutAccessoryView = moreInfoButton;
        return pinView;
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            let selectedLocation = view.annotation;
            let selectedCoordinate = view.annotation!.coordinate;
            var latitude = selectedCoordinate.latitude
            var longitude = selectedCoordinate.longitude
            var location:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let businessPlacemark = MKPlacemark(coordinate: selectedCoordinate, addressDictionary: nil)
            indicatedMapItem = selectedCoordinate;
            let resturantMock:Resturant = Resturant(dictionary: resultQueryDictionary)
            let dataArray = resultQueryDictionary["businesses"] as! NSArray
            var foundDisplayAddress:String = "Address not found"
            for business in dataArray {
                let obj = business as! NSDictionary
                var yelpBusinessMock: YelpBusiness = YelpBusiness(dictionary: obj)
                if yelpBusinessMock.latitude == view.annotation!.coordinate.latitude {
                    if yelpBusinessMock.longitude == view.annotation!.coordinate.longitude {
                        attractionDict = obj;
                        foundDisplayAddress = yelpBusinessMock.displayAddress
                        businessMock = Business(dictionary: obj)
                    }
                }
            }
            attractionLocationString = foundDisplayAddress
            performSegueWithIdentifier("attractionToDetail", sender: view);
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "attractionToDetail" {
            if let _annotation = (sender as? MKAnnotationView)?.annotation {
                if let ivc = segue.destinationViewController as? AttractionsDetailViewController {
                    ivc.attractionLocation = self.indicatedMapItem
                    ivc.attractionDetailAddressString = self.attractionLocationString
                    ivc.currentBusiness = self.attractionDict
                    ivc.businessToUse = self.businessMock
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categoriesList.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return categoriesList[section];
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = categoriesList[section];
        let sectionArray = categoryDictionary[sectionTitle];
        return sectionArray!.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        let sectionTitle = categoriesList[indexPath.section]
        var sectionArray = categoryDictionary[sectionTitle];
        let itemInArray = sectionArray?[indexPath.row];
        cell.textLabel?.text = itemInArray;
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        AttractionsTableView.backgroundColor = UIColor.clearColor()
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionTitle = categoriesList[indexPath.section]
        var sectionArray = categoryDictionary[sectionTitle];
        let itemInArray = sectionArray?[indexPath.row];
        performYelpSearch(itemInArray!)
        self.attractionsTabView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
}