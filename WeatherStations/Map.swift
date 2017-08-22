//
//  Map.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/20/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import MapKit

class Map {
    
    var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1500000
    
    // ----------------------------------------------------------
    // EXTERNAL
    init(mapInEditor: MKMapView){
        mapView = mapInEditor
        
        // Starts the Map view and focus it on Fresno, CA
        let initialLocation = CLLocation(latitude: 36.746841, longitude: -119.772591)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapTapped(location: CGPoint) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        // Creates a new annotation where user tapped and updates data for it
        addTappedAnnotation(location: location)
        
        // Gets 5 random stations nearby and
        showOtherStations()
    }
    
    // ----------------------------------------------------------
    // INTERNAL
    func getMapView()->MKMapView{
        return mapView
    }
    
    func addTappedAnnotation(location : CGPoint) {
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation to view
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = String(coordinate.latitude)
        annotation.subtitle = String(coordinate.longitude)
        
        // Display annotation pin on map
        mapView.addAnnotation(annotation)
        
        // Display details on annotation pin
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
    }
    
    func showOtherStations(){
        //
    }
    

}
