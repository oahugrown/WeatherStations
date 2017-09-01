//
//  WeatherUnderground.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/22/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import Foundation


class WeatherUnderground {
    let key: String = "44420252a5dfc9af"
    let preKey: String = "http://api.wunderground.com/api/"
    let fileExt: String = ".json"
    let geoLookup: String = "/geolookup/q/"
    
    var postKey: String = "postKey"
    
    var tappedLocation: Dictionary<String, AnyObject>?
    var neighborPWStations: Array<Dictionary<String, AnyObject>>?
    var neighborAPStations: Array<Dictionary<String, AnyObject>>?
    
    
    init() {
    }
    
    
    // Update data to new location
    func update(_latitude: Double, _longitude: Double) {
        
        // Concatenate postkey to geolookup string
        postKey = String("\(geoLookup)\(_latitude),\(_longitude)")
        
        requestData()
    }
    
    
    // Getting data from new location
    private func requestData(){
        let urlString = String(preKey + key + postKey + fileExt)
        let semaphore = DispatchSemaphore(value: 0)
        
        // request url
        let url = URL(string: urlString!)
        let session = URLSession.shared
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            // Pull data from the request
            self.extractData(_data: data)
            semaphore.signal()
        })
        
        task.resume()
        // waiting for download to finish
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    // Extracts and stores data
    private func extractData(_data: Data?){
        let json: Any?
        if (_data == nil) {
            print("_data nil: WeatherUngrounder.extractData()")
            return
        }
        
        do {
            json = try JSONSerialization.jsonObject(with: _data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        }
            
        catch {
            return
        }
        
        if let dict = json as? Dictionary<String, AnyObject> {
            
            // Get tapped data
            if let dataLocation = dict["location"] as? Dictionary<String, AnyObject> {
                tappedLocation = dataLocation
                
                neighborPWStations?.removeAll()
                neighborAPStations?.removeAll()
                
                // Getting neighborStations
                if let nearbyStations = dataLocation["nearby_weather_stations"] as? Dictionary<String, AnyObject> {
                    if let pws = nearbyStations["pws"] as? Dictionary<String, AnyObject> {
                        neighborPWStations = pws["station"] as? Array<Dictionary<String, AnyObject>>
                    }
                        
                    if let airport = nearbyStations["airport"] as? Dictionary<String, AnyObject> {
                        neighborAPStations = airport["station"] as? Array<Dictionary<String, AnyObject>>
                    }
                }
                
                // Updating Blackboard
                updateBlackboard()
                return  // hits if extraction was successful
            }
        }
        print("Failed to extract tappedLocation")
        Blackboard.data.validData = false
    }
    
    private func updateBlackboard(){
        Blackboard.data.tappedLocation = tappedLocation
        Blackboard.data.neighborAPStations = neighborAPStations
        Blackboard.data.neighborPWStations = neighborPWStations
        Blackboard.data.validData = true
    }
}


