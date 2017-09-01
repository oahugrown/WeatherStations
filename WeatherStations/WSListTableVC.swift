//
//  WSListTableViewController.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/30/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import Foundation
import UIKit

struct Station{
    var cityState: String?
    var temp: String?
    var type: String?
}

class WSListTableVC: UITableViewController {
    let cellID: String = "WSListTableViewCell"

    var stations = Array<Station>()
    
    // calls multiple times in lifetime right before view shows for the user
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("what")
        
        loadStations()
    }
    
    
    // setting up one section for the tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // making sure our table has the same number of cells as
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    
    // Setup the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Finding the cell to modify by cellID from the IB
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? WSListTableViewCell
            else {
            fatalError("The dequeued cell is not an instance of WSLIstTableViewCell.")
        }
        
        // Configure cell elements
        let station = stations[indexPath.row]
        cell.cityState.text = station.cityState
        cell.temp.text = station.temp
        cell.stationType.text = station.type
        
        return cell
    }
    
    
    private func loadStations() {
        var apStationIndex: Int = 0
        stations = []
        
        for index in 0...50 {
            var station = Station()
            
            // For personal weather stations
            if (index < (Blackboard.data.neighborPWStations?.count)!) {
                station.cityState = Blackboard.data.getPWStationCityState(index: index)
                station.type = "Personal"
            }
                
            // no more stations to add so break
            else if (apStationIndex >= (Blackboard.data.neighborAPStations?.count)!){
                return
            }
            
            // For airport weather stations
            else {
                station.cityState = Blackboard.data.getPWStationCityState(index: apStationIndex)
                apStationIndex += 1
                station.type = "Airport"
            }
            stations.append(station)
        }
        
//        station.cityState = "San Francisco, CA"
//        station.temp = "64.1 F (17.8 C)"
//        station.type = "personal"
//        
//        stations.append(station)
//        stations.append(station)
//        stations.append(station)
    }
}

