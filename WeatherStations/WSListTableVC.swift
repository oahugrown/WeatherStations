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

class WSListTableVC: UITableViewController, WSDelegate {
    let cellID: String = "WSListTableViewCell"
    
    var stations = Array<Station>()
    var wsData: WSData = WSData()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoadStations()
        self.tableView.reloadData()
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
    
    
    func ChangeData(_data: WSData) {
        wsData = _data
    }
    
    
    private func LoadStations(){
        stations = []
        
        // Bail if the data isn't valid
        if !(wsData.isValid){
            return
        }
        
        var apStationIndex: Int = 0
    
        // update stations list
        for index in 0...50 {
            var station = Station()
            station.temp = wsData.temperature
    
            // For personal weather stations
            if (index < (wsData.neighborPWStations?.count)!) {
            station.cityState = wsData.getPWStationCityState(index: index)
            station.type = "Personal"
            }
    
                // no more stations to add so break
            else if (apStationIndex >= (wsData.neighborAPStations?.count)!) {
                break
            }
    
                // For airport weather stations
            else {
                station.cityState = wsData.getPWStationCityState(index: apStationIndex)
                apStationIndex += 1
                station.type = "Airport"
            }
            stations.append(station)
        }
    
        // sort them alphabetically by City, State
        self.stations.sort {
            $0.cityState?.localizedCaseInsensitiveCompare($1.cityState!) == ComparisonResult.orderedAscending
        }
    }
}

