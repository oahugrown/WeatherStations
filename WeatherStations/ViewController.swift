//
//  ViewController.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/10/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1500000

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startMap() {
        // Starts the Map view and focus it on Fresno, CA
        let initialLocation = CLLocation(latitude: 36.746841, longitude: -119.772591)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        // Get tapped coordinates
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation to view
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = String(coordinate.latitude)
        annotation.subtitle = String(coordinate.longitude)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
        displayClosestWeatherStations()
    }
    
    func displayClosestWeatherStations(){
        //
    }
}

