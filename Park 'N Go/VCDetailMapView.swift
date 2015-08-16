//
//  VCDetailMapView.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/8/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

extension detailViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if(annotation is MKUserLocation) {
            println("This guy....");
            return nil;
        }
        let reuseId = "pin";
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView;
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId);
            pinView!.canShowCallout = true;
            pinView!.animatesDrop = true;
            var rightButton: UIButton;
        }
        var rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton;
        pinView?.rightCalloutAccessoryView = rightButton;
        return pinView;
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let selectedLocation = view.annotation;
        if(control == view.rightCalloutAccessoryView) {
            let currentLocMapItem = MKMapItem.mapItemForCurrentLocation();
            let selectedPlacemark = MKPlacemark(coordinate: selectedLocation.coordinate, addressDictionary: nil);
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
            let mapItems = [currentLocMapItem, selectedMapItem]
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            
            MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)
        }
    }
    
    
}
