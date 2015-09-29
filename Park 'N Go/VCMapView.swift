//
//  VCMapView.swift
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/7/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.

import Foundation
import MapKit
import AddressBook

extension ViewController {
    

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation) {
            return nil;
        }
        let reuseId = "pin";
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView;
        
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId);
            pinView!.canShowCallout = true;
            pinView!.animatesDrop = true;

        }
        
        // Use custom image of a car or something to distinguish directions
//        let leftButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton;
        let leftButton = UIButton(type: UIButtonType.DetailDisclosure)
        pinView?.leftCalloutAccessoryView = leftButton;
        return pinView;

    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedLoc = view.annotation
            if(control == view.leftCalloutAccessoryView) {
                let currentLocMapItem = MKMapItem.mapItemForCurrentLocation()
                let selectedPlacemark = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
                let selectedMapItem = MKMapItem(placemark: selectedPlacemark);
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
                let mapItems = [currentLocMapItem, selectedMapItem]

                MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)
            }
            
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay);
        renderer.strokeColor = UIColor.blueColor();
        renderer.lineWidth = 5.0;
        return renderer;
    }
    

    }
