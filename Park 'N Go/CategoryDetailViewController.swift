//
//  CategoryDetailViewController.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/13/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import UIKit

var searchString:String?;

class CategoryDetailViewController: UIViewController, UITableViewDelegate {
    

    @IBOutlet weak var categoryLabel: UILabel!
    var categoryName:String?;
    var foodCategories = [CategoryModel]();
    

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"));
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes"));
        var downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes"));
        
        leftSwipe.direction = .Left;
        rightSwipe.direction = .Right;
        downSwipe.direction = .Down;
        
        view.addGestureRecognizer(leftSwipe);
        view.addGestureRecognizer(rightSwipe);
        view.addGestureRecognizer(downSwipe);
        
        setupCategory()
        
        
        self.categoryLabel.text = categoryName;
        // Do any additional setup after loading the view.
    }
    
    func setupCategory() {
        var asianFood = CategoryModel(category: "Asian Food", imageName: "background_2.jpg");
        var mexicanFood = CategoryModel(category: "Mexican Food", imageName: "background_2.jpg");
        var fastFood = CategoryModel(category: "Fast Food", imageName: "background_2.jpg");
        var MiddleEasternFood = CategoryModel(category:"Middle Eastern Food", imageName: "background_2.jpg");
        
        foodCategories.append(asianFood);
        foodCategories.append(mexicanFood);
        foodCategories.append(fastFood);
        foodCategories.append(MiddleEasternFood);
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if(sender.direction == .Down) {
            println("Swipe down");
            self.dismissViewControllerAnimated(true, completion: nil);
        }
    }
    

//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.dismissViewControllerAnimated(true, completion: nil);
//    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CustomCategoryCell = tableView.dequeueReusableCellWithIdentifier("Cell2") as! CustomCategoryCell;
        
        let category = foodCategories[indexPath.row];
                
        return cell;
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodCategories.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let foodCategory  = foodCategories[indexPath.row];
        
        searchString = foodCategory.category;
        
        var mockAttractionsVC:AttractionsVC = AttractionsVC();
        
        
//        self.presentViewController(AttractionsVC(), animated: true) { () -> Void in
//            mockAttractionsVC.performSearch(foodCategory.category);
//
//        }
        
        
        
    }
   

    
    
}
