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
    var map : Map!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = Map(mapInEditor: mapView)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {

        let location = sender.location(in: map.getMapView())
        map.mapTapped(location: location);
    }
}

