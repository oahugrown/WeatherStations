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
    let conditionsLookUp: String = "/conditions/q/"
    
    var postKey: String = "postKey"
    
    let wsData: WSData = WSData()
    
    init() {
        
    }
    
    // Update data to new location
    func update(_latitude: Double, _longitude: Double) {
        
        // Concatenate postkey to geolookup string
        postKey = String("\(geoLookup)\(_latitude),\(_longitude)")
        
        // Gathering station list information
        requestData()
        
        // Getting temperature
        if let requestURL = wsData.tappedLocation!["requesturl"] as? String {
            // Remove ".html" from requestURL
            let endIndex = requestURL.index(requestURL.endIndex, offsetBy: -5)
            let url = requestURL.substring(to: endIndex)
            
            postKey = String("\(preKey)\(key)\(conditionsLookUp)\(url)\(fileExt)")
            requestTempData(_urlString: postKey)
        }
    }
    
    private func requestTempData(_urlString: String) {
        let semaphore = DispatchSemaphore(value: 0)

        // request url
        let url = URL(string: _urlString)
        let session = URLSession.shared
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            // Pull temperature from
            self.extractTemp(_data: data)
            semaphore.signal()
        })
        
        task.resume()
        // waiting for download to finish
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    // Getting data from new location
    private func requestData() {
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
    
    // Extracts and updates blackboard
    private func extractTemp(_data: Data?) {
        let json: Any?
        if (_data == nil) {
            print("_data nil: WeatherUngrounder.extractTemp()")
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
            if let currentObservation = dict["current_observation"] as? Dictionary<String, AnyObject> {
                
                if let temperatureString = currentObservation["temperature_string"] as? String {
                    // Updating Blackboard
                    wsData.temperature = temperatureString
                
                    return  // hits if extraction was successful
                }
            }
        }
        wsData.temperature = nil
        print("Failed to extract temperature")
    }
    
    // Extracts and stores data
    private func extractData(_data: Data?) {
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
                wsData.tappedLocation = dataLocation
                
                wsData.neighborPWStations?.removeAll()
                wsData.neighborAPStations?.removeAll()
                
                // Getting neighborStations
                if let nearbyStations = dataLocation["nearby_weather_stations"] as? Dictionary<String, AnyObject> {
                    if let pws = nearbyStations["pws"] as? Dictionary<String, AnyObject> {
                        wsData.neighborPWStations = pws["station"] as? Array<Dictionary<String, AnyObject>>
                    }
                        
                    if let airport = nearbyStations["airport"] as? Dictionary<String, AnyObject> {
                        wsData.neighborAPStations = airport["station"] as? Array<Dictionary<String, AnyObject>>
                    }
                }
                wsData.isValid = true
                return  // hits if extraction was successful
            }
        }
        print("Failed to extract tappedLocation")
        wsData.isValid = false
    }
}


