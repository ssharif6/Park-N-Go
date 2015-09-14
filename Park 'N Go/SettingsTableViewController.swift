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
var numResultsGlobal:Int = 5

class SettingsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var radiusPIcker: UIPickerView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var numResultsPicker: UIPickerView!
    @IBOutlet weak var numResultsLabel: UILabel!
    @IBOutlet weak var metricsSwitch: UISwitch!
    @IBOutlet weak var sortByPicker: UIPickerView!
    @IBOutlet weak var sortbyLabel: UILabel!
    var radiusTapped = false
    var sortByTapped: Bool = false
    var radiusPickerHidden = false
    var sortByPickerHidden:Bool = false
    var numResultsTapped = false
    var numResultsPickerHIdden: Bool = false
    let radiusPickerData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let sortByPickerData = ["Best Matched", "Distance", "Highest Rated"]
    let numResultsPickerData = [5, 10, 15, 20, 25, 30]
    
    var currentRowRadius:Int = 0
    var currentRowSortBy:Int = 0
    var currentRowNumResults:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusPIcker.delegate = self
        radiusPIcker.dataSource = self
        sortByPicker.delegate = self
        sortByPicker.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.settingsTableView.tableFooterView = UIView(frame: CGRectZero)

        // Set metrics default to false
        metricsSwitch.setOn(false, animated: true)
        // Load from User Defaults
        if (NSUserDefaults.standardUserDefaults().stringForKey("radiusSettingsChanged") != nil) {
            detailLabel.text = (NSUserDefaults.standardUserDefaults().stringForKey("radiusSettingsChanged"))
        }
        if ((NSUserDefaults.standardUserDefaults().stringForKey("sortBySettingsChanged")) != nil) {
            sortbyLabel.text = (NSUserDefaults.standardUserDefaults().stringForKey("sortBySettingsChanged"))
        }
        if (NSUserDefaults.standardUserDefaults().stringForKey("numResultsSettingsChanged") != nil) {
            numResultsLabel.text = (NSUserDefaults.standardUserDefaults().stringForKey("numResultsSettingsChanged"))
        }
    }
    
    func radiusChanged() {
        detailLabel.text = "1" // Sets the Initial default value of radius to 1
    }
    func toggleNumResultsPicker() {
        numResultsPickerHIdden = !numResultsPickerHIdden
        settingsTableView.beginUpdates()
        settingsTableView.endUpdates()
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
        } else if pickerView == numResultsPicker {
            return numResultsPickerData.count
        } else {
            return sortByPickerData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == radiusPIcker {
            radiusGlobal = row + 1
            return String(radiusPickerData[row])
        } else if pickerView == numResultsPicker {
            numResultsGlobal = numResultsPickerData[row]
            return String(numResultsPickerData[row])
        } else {
            sortGlobal = row
            return String(sortByPickerData[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == radiusPIcker {
            if row != currentRowRadius {
                NSNotificationCenter.defaultCenter().postNotificationName("radiusSettingsChanged", object: nil)
                currentRowRadius = row
            }
            if (NSUserDefaults.standardUserDefaults().stringForKey("radiusSettingsChanged") != nil) {
                detailLabel.text = (NSUserDefaults.standardUserDefaults().stringForKey("radiusSettingsChanged"))
            }
            NSUserDefaults.standardUserDefaults().setObject(String(radiusPickerData[row]) as String, forKey: "radiusSettingsChanged")
            detailLabel.text = String(radiusPickerData[row])
        }
        else if pickerView == numResultsPicker {
            if row != currentRowNumResults {
                NSNotificationCenter.defaultCenter().postNotificationName("numResultsPickerChanged", object: nil)
            }
            if (NSUserDefaults.standardUserDefaults().stringForKey("numResultsSettingsChanged") != nil) {
                numResultsLabel.text = (NSUserDefaults.standardUserDefaults().stringForKey("numResultsSettingsChanged"))
            }
            NSUserDefaults.standardUserDefaults().setObject(String(numResultsPickerData[row]) as String, forKey: "numResultsSettingsChanged")
            numResultsLabel.text = String(numResultsPickerData[row])
            currentRowNumResults = row
            
        } else {
            // Sort By
            if row != currentRowSortBy {
                NSNotificationCenter.defaultCenter().postNotificationName("sortBySettingsChanged", object: nil)
            }
            if (NSUserDefaults.standardUserDefaults().stringForKey("sortBySettingsChanged") != nil) {
                sortbyLabel.text = (NSUserDefaults.standardUserDefaults().stringForKey("sortBySettingsChanged"))
            }
            NSUserDefaults.standardUserDefaults().setObject(String(sortByPickerData[row]) as String, forKey: "sortBySettingsChanged")
            sortbyLabel.text = String(sortByPickerData[row])
            currentRowSortBy = row
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 && numResultsTapped == false {
            return 0
        }
        if indexPath.row == 4 && radiusTapped == false {
            return 0
        }
        if indexPath.row == 6 && sortByTapped == false {
            return 0
        }
        else if indexPath.section == 1 && indexPath.row == 1 && numResultsTapped == true {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        else if indexPath.section == 1 && indexPath.row == 3 && radiusTapped == true {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        else if indexPath.section == 1 && indexPath.row == 5 && sortByTapped == true {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 3 && radiusTapped == false {
            radiusTapped = true
            toggleRadiusPicker()
        }
        else if indexPath.section == 1 && indexPath.row == 3 && radiusTapped == true {
            radiusTapped = false
            toggleRadiusPicker()
        }
        if indexPath.section == 1 && indexPath.row == 1 && numResultsTapped == false {
            numResultsTapped = true
            toggleNumResultsPicker()
        } else if indexPath.section == 1 && indexPath.row == 1 && numResultsTapped == true {
            numResultsTapped = false
            toggleNumResultsPicker()
        }
        else {
            if indexPath.section == 1 && indexPath.row == 5 && sortByTapped == false {
                sortByTapped = true
                toggleSortByPicker()
            }
            else if indexPath.section == 1 && indexPath.row == 5 && sortByTapped == true {
                sortByTapped = false
                toggleSortByPicker()
            }
            else {
//                radiusTapped = false
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
