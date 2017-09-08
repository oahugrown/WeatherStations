//
//  Map.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/20/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import MapKit
import Foundation

protocol WSDelegate: class {
    func ChangeData(_data: WSData)
}

enum StationType {case personal, airport }

class Map {
    
    var mapView: MKMapView!
    var weatherUnderground: WeatherUnderground!
    var stationType: StationType = StationType.personal
    var wsData: WSData!
    
    var tappedPin: Pin = Pin()
    
    // Fresno, CA Location
    let startLong: Double = -122.395234
    let startLat: Double = 37.776289
    let regionRadius: CLLocationDistance = 150000
    
    // Delegate to fire
    weak var delegate: WSDelegate?
    
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
        // TO DO: Turn this into a bool check that data successfully update
        weatherUnderground.update(_latitude: coordinate.latitude, _longitude: coordinate.longitude)
        
        wsData = weatherUnderground.wsData
        
        // Creates a new annotation where user tapped and updates data for it
        updateTappedPin(_coordinate: coordinate)
        
        refreshPins()
        
        // fire off the delegate
        if delegate != nil {
            delegate!.ChangeData(_data: wsData)
        }
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
        tappedPin.title = wsData.getCityState(dict: wsData.tappedLocation!)
        
        // Setup temp if temperature is valid
        let temp = wsData.temperature
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
                if index >= wsData.getPWStationCount() {
                    break
                }
                station = wsData.getNearbyPWSStationCoor(index: index)
            }
                
            else if stationType == StationType.airport {
                if index >= wsData.getAPStationCount() {
                    break
                }
                station = wsData.getNearbyAPStationCoor(index: index)
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: station[0], longitude: station[1])
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
}
