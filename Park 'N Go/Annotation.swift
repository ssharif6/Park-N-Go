//
//  Annotation.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/7/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import AddressBook

class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D;
    var title2: String;
    var locationName: String;
    
    init(coordinate: CLLocationCoordinate2D, title: String, locationName: String) {
        self.coordinate = coordinate;
        self.title2 = title;
        self.locationName = locationName;
        
        super.init()

    }
    var subtitle2: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle2]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title2
        
        return mapItem
    }

}