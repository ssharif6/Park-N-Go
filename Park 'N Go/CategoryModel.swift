//
//  CategoryModel.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/13/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation

class CategoryModel {
    var category = ""
    var imageName = ""
    
    init(category:String, imageName:String) {
        self.category = category;
        self.imageName = imageName;
    }
}
