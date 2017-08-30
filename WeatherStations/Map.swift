//
//  Map.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/20/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import MapKit
import Foundation

class Map {
    
    var mapView: MKMapView!
    var weatherUnderground: WeatherUnderground!
    let regionRadius: CLLocationDistance = 400000
    
    // San Franciso Location
    let startLong: Double = -122.395234
    let startLat: Double = 37.776289
    
    
    // ----------------------------------------------------------
    // EXTERNAL

    init(_mapInEditor: MKMapView){
        mapView = _mapInEditor
        weatherUnderground = WeatherUnderground()
        
        // Starts the Map view and focus it on Fresno, CA
        let initialLocation = CLLocation(latitude: 36.746841, longitude: -119.772591)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func getMapView()->MKMapView {
        return mapView
    }
    
    
    func mapTapped(_location: CGPoint) {
        // Clear the map view of annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Getting map coordinates
        let coordinate = mapView.convert(_location,toCoordinateFrom: mapView)
        
        // Update weather data
        weatherUnderground.update(_latitude: coordinate.latitude, _longitude: coordinate.longitude)
        
        // Creates a new annotation where user tapped and updates data for it
        addTappedAnnotation(_coordinate: coordinate)
        
        // Gets 5 random stations nearby and
        showOtherStations()
    }
    
    // ----------------------------------------------------------
    // INTERNAL
    
    private func addTappedAnnotation(_coordinate: CLLocationCoordinate2D) {

        // Add annotation to view
        let annotation = MKPointAnnotation()
        annotation.coordinate = _coordinate
        annotation.title = weatherUnderground.getCityState(dict: weatherUnderground.tappedLocation!)
        
        // Display annotation pin on map
        mapView.addAnnotation(annotation)
        
        // Display details on annotation pin
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
    }
    
     func showOtherStations() {
        for index in 0...4 {
            let annotation = MKPointAnnotation()
            if index >= (weatherUnderground.neighborPWStations?.count)! {
                break
            }
            
            let station = weatherUnderground.getNearbyPWSStationCoor(index: index)
            let coordinate = CLLocationCoordinate2D(latitude: station[0], longitude: station[1])
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
        }
    }
}
