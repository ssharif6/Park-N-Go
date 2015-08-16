//
//  Artwork.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/7/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation
import MapKit
import AddressBook


class Artwork: NSObject, MKAnnotation {
    let title: String
    let locationName: String
    //let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        //self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    var subtitle: String {
        return locationName
    }
    
    // Parses JSON data
    
    class func fromJSON(json: [JSONValue]) -> Artwork? {
        // 1
        var title: String;
        if let titleOrNil = json[16].string {
            title = titleOrNil
        } else {
            title = ""
        }
        let locationName = json[12].string
        let discipline = json[15].string
        
        // 2
        let latitude = (json[18].string! as NSString).doubleValue
        let longitude = (json[19].string! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return Artwork(title: title, locationName: locationName!, coordinate: coordinate)
    }
    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
//    func pinColor() -> MKPinAnnotationColor  {
//        switch discipline {
//        case "Sculpture", "Plaque":
//            return .Red
//        case "Mural", "Monument":
//            return .Purple
//        default:
//            return .Green
//        }
//    }
}