//
//  AttractionStackViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 1/14/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit

class AttractionStackViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var attractionTitle: UILabel!
    @IBOutlet weak var attractionImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        containerView.addGestureRecognizer(gesture)
        containerView.userInteractionEnabled = true
        
    }
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view) // where it starts and ends
        let label = gesture.view!
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        
        if(gesture.state == UIGestureRecognizerState.Ended) {
            if label.center.x < 100 {
                print("Not chosen")
            } else if label.center.x > self.view.bounds.width - 100 {
                print("chosen")
            }
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
