//
//  Map.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/20/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import MapKit
import Foundation

enum StationType {case personal, airport }

class Map {
    
    var mapView: MKMapView!
    var weatherUnderground: WeatherUnderground!
    var stationType: StationType = StationType.personal
    
    var tappedPin: Pin = Pin()
    
    // Fresno, CA Location
    let startLong: Double = -122.395234
    let startLat: Double = 37.776289
    let regionRadius: CLLocationDistance = 150000
    
    
    // ----------------------------------------------------------
    // EXTERNAL
    
    init(_mapInEditor: MKMapView){
        
        mapView = _mapInEditor
        weatherUnderground = WeatherUnderground()
        
        // Starts the Map view and focus it on Fresno, CA
        let initialLocation = CLLocation(latitude: 36.746841, longitude: -119.772591)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        
        // Set view region on map
        mapView.setRegion(coordinateRegion, animated: true)
        
        // set tapped pin
        tappedPin.annotationView.pinTintColor = MKPinAnnotationView.greenPinColor()
        tappedPin.annotationView.animatesDrop = true
        tappedPin.annotationView.canShowCallout = true
        
    }
    
    
    func getMapView()->MKMapView {
        return mapView
    }
    
    
    func mapTapped(_location: CGPoint) {
        // Getting map coordinates
        let coordinate = mapView.convert(_location,toCoordinateFrom: mapView)
        
        // Update weather data
        weatherUnderground.update(_latitude: coordinate.latitude, _longitude: coordinate.longitude)
        
        // If data update failed, bail
        if !Blackboard.data.validData {
            return
        }
        
        // Creates a new annotation where user tapped and updates data for it
        updateTappedPin(_coordinate: coordinate)
        
        refreshPins()
    }
    
    // Clears all annotations on the map, and redisplays all pins
    func refreshPins(){
        mapView.removeAnnotations(mapView.annotations)
        
        // Display tapped pin on map
        mapView.addAnnotation(tappedPin)
        
        showOtherStations()
        
        // Display details on tapped pin
        self.mapView.selectAnnotation(tappedPin, animated: true)
    }
    
    
    // ----------------------------------------------------------
    // INTERNAL
    
    private func updateTappedPin(_coordinate: CLLocationCoordinate2D) {

        // Setup tapped pin
        tappedPin.coordinate = _coordinate
        tappedPin.title = Blackboard.data.getCityState(dict: weatherUnderground.tappedLocation!)
        
        // Setup temp if temperature is valid
        let temp = Blackboard.data.temperature
        if temp == nil {
            return
        }
        tappedPin.subtitle = temp
    }
    
    
    private func showOtherStations() {
        for index in 0...4 {
            let annotation = Pin()
            var station = Array<Double>()
            
            if stationType == StationType.personal {
                if index >= Blackboard.data.getPWStationCount() {
                    break
                }
                station = Blackboard.data.getNearbyPWSStationCoor(index: index)
            }
                
            else if stationType == StationType.airport {
                if index >= Blackboard.data.getAPStationCount() {
                    break
                }
                station = Blackboard.data.getNearbyAPStationCoor(index: index)
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: station[0], longitude: station[1])
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
}
