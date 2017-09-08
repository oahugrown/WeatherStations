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
    var tableVC: WSListTableVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = Map(_mapInEditor: mapView)
        
        tableVC = self.storyboard?.instantiateViewController(withIdentifier: "TableVC") as? WSListTableVC
        map.delegate = tableVC        
    }
    
    // Called when the user hits the "List" button 
    @IBAction func listView(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(tableVC!, animated: true)
    }

    
    // Notifies map where the user tapped so then map can get the pin information
    @IBAction func handleTap(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .ended) {
            let location = sender.location(in: map.getMapView())
            map.mapTapped(_location: location);
        
            if !active {
                active = true
                segmentController.isEnabled = true
                listButton.isEnabled = true
            }
        }
    }

    
    // Segment control for switching between viewing airport and personal stations
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

