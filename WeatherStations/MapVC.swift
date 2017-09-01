//
//  ViewController.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/10/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var listButton: UIBarButtonItem!
   
    var active: Bool = false
    var map : Map!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = Map(_mapInEditor: mapView)
        Blackboard.data.map = map
    }
    
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {

        let location = sender.location(in: map.getMapView())
        map.mapTapped(_location: location);
        
        if !active {
            active = true
            segmentController.isEnabled = true
            listButton.isEnabled = true
        }
    }
    
    @IBAction func changeStationType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            map.stationType = StationType.airport
        default:
            map.stationType = StationType.personal
        }
        map.refreshPins()
    }
}

