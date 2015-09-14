//
//  YelpTableViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 8/28/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit
import MapKit

class YelpTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var businessToUseTVC:Business!
    var businessDict: NSDictionary!
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.backgroundView = UIImageView(image: UIImage(named: "bg"))
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView(frame: CGRectZero)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businessArray != nil {
            return businessArray.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YelpTableBusinessCell", forIndexPath: indexPath) as! YelpTableBusinessCell
        var business:Business = Business(dictionary: businessArray[indexPath.row] as! NSDictionary)
        cell.business = business
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        businessDict = businessArray[indexPath.row] as! NSDictionary
        businessToUseTVC = Business(dictionary: businessArray[indexPath.row] as! NSDictionary)
        performSegueWithIdentifier("businessToDetailVC", sender: view);

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "businessToDetailVC" {
            if let ivc = segue.destinationViewController as? AttractionsDetailViewController {
                ivc.businessToUse = self.businessToUseTVC
                ivc.currentBusiness = self.businessDict
                var locationLatitude = businessToUseTVC.latitude
                var locationLongitude = businessToUseTVC.longitude
                var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationLatitude!, longitude: locationLongitude!)
                ivc.attractionLocation = locationCoordinate
//                ivc.attractionLocation = self.indicatedMapItem

            }
        }
    }

}
