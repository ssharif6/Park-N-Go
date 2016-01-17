//
//  BackTableVC.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 9/15/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        tableArray = ["Current Location", "Pinned Location", "What's Near You?"]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableArray[indexPath.row], forIndexPath: indexPath) 
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pinnedLocationSegue" {
            if let ivc = segue.destinationViewController as? detailViewController {
                ivc.toPass = title
            }
        }
    }
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
}