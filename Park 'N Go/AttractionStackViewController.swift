//
//  AttractionStackViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 1/14/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit
import Parse

class AttractionStackViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var attractionTitle: UILabel!
    @IBOutlet weak var attractionImage: UIImageView!
    
    var displayUserId = ""
    var queryString: String = ""
    var mostRecentObj: PFObject?
    
    override func viewDidLoad() {
        getFirstAttractionCard()
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        containerView.addGestureRecognizer(gesture)
        containerView.userInteractionEnabled = true
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getFirstAttractionCard()
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        containerView.addGestureRecognizer(gesture)
        containerView.userInteractionEnabled = true
        viewDidLoad()
    }

    var displayedUserId = ""
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" {
                updateAttractionCard(acceptedOrRejected)
                
                
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            
        }
        
        
    }
    
    func getFirstAttractionCard() {
        let query = PFQuery(className: "Business")
        do {
            let shit:PFObject = try query.getFirstObject()
            self.attractionTitle.text = shit["name"] as? String
            self.mostRecentObj = shit
            print(shit["name"] as? String)

        } catch {
            // do something
            print(error)
        }
    }
    
    
    func updateAttractionCard(status: String) {
        // Get the first attraction
        let businessQuery = PFQuery(className: "Business")
        businessQuery.limit = 1
        businessQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let objects = objects as [PFObject]! {
                for object in objects {
                    self.displayUserId = object.objectId!
                    let businessName = object["name"] as! String
                    print(businessName)
                    print(businessName + self.displayUserId)
                    self.attractionTitle.text = businessName
                    if status == "accepted" {
                        // Accepted Method
                    } else  {
                        // firstTime
                        do {
                            try object.delete()
                        } catch {
                            print("FUCK")
                        }
                        self.getFirstAttractionCard()
                    }
                }
            }
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
