//
//  FoodCategoryModel.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/13/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation

class FoodCategoryModel {
    
    var foodType = ""
    var imageName = ""
    
    init(foodType: String, imageName:String) {
        self.foodType = foodType;
        self.imageName = imageName;
    }
}