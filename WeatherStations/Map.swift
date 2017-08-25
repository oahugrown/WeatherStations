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
    
    func getMapView()->MKMapView {
        return mapView
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
    
    private func addTappedAnnotation(location: CGPoint) {
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // parse data
        let preKey: String = "http://api.wunderground.com/api/"
        let key: String = "44420252a5dfc9af"
        var postKey: String = "/conditions/q/CA/Fresno.json"
        let fileExt: String = ".json"
        postKey = String("/geolookup/q/\(coordinate.latitude),\(coordinate.longitude)")
        let urlString = String(preKey + key + postKey + fileExt)
        print(urlString!)
        
        // request url
        let url = URL(string: urlString!)
        let session = URLSession.shared
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            self.extractData(data: data)

        })
        
        task.resume()
        
        // Add annotation to view
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = getCityName(location: coordinate)
        annotation.subtitle = String(coordinate.longitude)
        
        // Display annotation pin on map
        mapView.addAnnotation(annotation)
        
        // Display details on annotation pin
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
    }
    
     func showOtherStations(){
        //
    }
    
    func extractData(data: Data?) {
        let json: Any?
        if (data == nil) {
            return
        }
        
        do {
            json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        }
        
        catch {
            return
        }
      
        if let dict = json as? [String: AnyObject] {

            if let dataLocation = dict["location"] as? [String: AnyObject] {
                print(dataLocation["city"]!)
            }
        }
        print("Done extracting")
    }
    
    func getCityName(location: CLLocationCoordinate2D)->String {
        
    return ""
    }

}
