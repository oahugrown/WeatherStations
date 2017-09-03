//
//  Blackboard.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/31/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import Foundation

final class Blackboard {
    static let data = Blackboard()
    
    var validData: Bool = false
    
    var map: Map!
    var tappedLocation: Dictionary<String, AnyObject>?
    var temperature: String?
    var neighborPWStations: Array<Dictionary<String, AnyObject>>?
    var neighborAPStations: Array<Dictionary<String, AnyObject>>?
    
    
    // returns in format "City, State"
    func getCityState(dict: Dictionary<String, AnyObject>)-> String {
        var result = String()
        
        if let city = dict["city"] as? String {
            if let state = dict["state"] as? String {
                result = String("\(city), \(state)")
            }
        }
        return result
    }
    
    
    // returns in format "City, State", for personal stations
    func getPWStationCityState(index: Int)-> String {
        if (index >= (neighborPWStations?.count)!){
            return ""
        }
        
        return getCityState(dict: (neighborPWStations?[index])!)
    }
    
    
    // returns in format "City, State", for airport stations
    func getAPStationCityState(index: Int)-> String {
        if (index >= (neighborAPStations?.count)!){
            return ""
        }
        
        return getCityState(dict: (neighborAPStations?[index])!)
    }
    
    
    // returns Array<Double>, index 0 = Latitdude, index 1 = Longitude, for personal stations
    func getNearbyPWSStationCoor(index: Int)-> Array<Double> {
        // Safety
        if (index >= (neighborPWStations?.count)!){
            return Array<Double>()
        }
        
        var result: Array<Double> = Array<Double> (repeatElement(0.0, count: 2))
        
        let stationLat = neighborPWStations?[index]["lat"] as! Double
        result[0] = stationLat
        
        let stationLon = neighborPWStations?[index]["lon"] as! Double
        result[1] = stationLon
        
        return result
    }
    
    
    // returns Array<Double>, index 0 = Latitdude, index 1 = Longitude, for airport stations
    func getNearbyAPStationCoor(index: Int)-> Array<Double> {
        // Safety
        if (index >= (neighborPWStations?.count)!){
            return Array<Double>()
        }
        
        var result: Array<Double> = Array<Double> (repeatElement(0.0, count: 2))
        
        let stationLat = neighborPWStations?[index]["lat"] as! Double
        result[0] = stationLat
        
        let stationLon = neighborPWStations?[index]["lon"] as! Double
        result[1] = stationLon
        
        return result
    }
    
    
    func getAPStationCount()-> Int {
        return neighborAPStations!.count
    }
    
    
    func getPWStationCount()-> Int {
        return neighborPWStations!.count
    }
}


