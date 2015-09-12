//
//  SettingsTableViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 9/11/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit

var sortGlobal:Int = 0
var radiusGlobal:Int = 1

class SettingsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var radiusPIcker: UIPickerView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var metricsSwitch: UISwitch!
    @IBOutlet weak var sortByPicker: UIPickerView!
    @IBOutlet weak var sortbyLabel: UILabel!
    var radiusTapped = false
    var sortByTapped: Bool = false
    var radiusPickerHidden = false
    var sortByPickerHidden:Bool = false
    let radiusPickerData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let sortByPickerData = ["Best Matched", "Distance", "Highest Rated"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusPIcker.delegate = self
        radiusPIcker.dataSource = self
        sortByPicker.delegate = self
        sortByPicker.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        // Set metrics default to false
        metricsSwitch.setOn(false, animated: true)
        
        self.settingsTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func radiusChanged() {
        detailLabel.text = "1" // Sets the Initial default value of radius to 1
    }
    
    func toggleSortByPicker() {
        sortByPickerHidden = !sortByPickerHidden
        settingsTableView.beginUpdates()
        settingsTableView.endUpdates()
    }
    
    func toggleRadiusPicker() {
        radiusPickerHidden = !radiusPickerHidden
        settingsTableView.beginUpdates()
        settingsTableView.endUpdates()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == radiusPIcker {
            return radiusPickerData.count
        } else {
            return sortByPickerData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == radiusPIcker {
            radiusGlobal = row + 1
            return String(radiusPickerData[row])
        } else {
            // Sort By
            sortGlobal = row
            return String(sortByPickerData[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == radiusPIcker {
            if row != 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("radiusSettingsChanged", object: nil)
            }
            detailLabel.text = String(radiusPickerData[row])
        } else {
            // Sort By
            if row != 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("sortBySettingsChanged", object: nil)
            }
            sortbyLabel.text = String(sortByPickerData[row])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 && radiusTapped == false {
            return 0
        }
        if indexPath.row == 4 && sortByTapped == false {
            return 0
        }
        else if indexPath.section == 1 && indexPath.row == 1 && radiusTapped == true {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        else if indexPath.section == 1 && indexPath.row == 3 && sortByTapped == true {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 && radiusTapped == false {
            radiusTapped = true
            toggleRadiusPicker()
        }
        else if indexPath.section == 1 && indexPath.row == 1 && radiusTapped == true {
            radiusTapped = false
            toggleRadiusPicker()
        }
        else {
            if indexPath.section == 1 && indexPath.row == 3 && sortByTapped == false {
                sortByTapped = true
                toggleSortByPicker()
            }
            else if indexPath.section == 1 && indexPath.row == 3 && sortByTapped == true {
                sortByTapped = false
                toggleSortByPicker()
            }
            else {
                radiusTapped = false
                toggleRadiusPicker()
                toggleSortByPicker()
            }

        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
