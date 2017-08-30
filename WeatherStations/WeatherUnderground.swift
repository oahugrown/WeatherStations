//
//  WeatherUnderground.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/22/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import Foundation

struct Station{
    var cityState: String?
    var temp: String?
}

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
    func requestData(){
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
        semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    // Extracts and stores data
    func extractData(_data: Data?){
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
                
                // Getting neighborStations
                if let nearbyStations = dataLocation["nearby_weather_stations"] as? Dictionary<String, AnyObject> {
                    if let pws = nearbyStations["pws"] as? Dictionary<String, AnyObject> {
                        neighborPWStations = pws["station"] as? Array<Dictionary<String, AnyObject>>
                    }
                        
                    if let airport = nearbyStations["airport"] as? Dictionary<String, AnyObject> {
                        neighborAPStations = airport["station"] as? Array<Dictionary<String, AnyObject>>
                    }
                }
            }
        }
    }
    
    // returns in format "City, State"
    func getCityState(dict: Dictionary<String, AnyObject>)-> String {
        var result: String = ""
        
        if let city = dict["city"] as? String {
            if let state = dict["state"] as? String {
                result = String("\(city), \(state)")
            }
        }
        return result
    }
    
    // returns Array<Double>, index 0 = Latitdude, index 1 = Longitude
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
    
    // returns Array<Double>, index 0 = Latitdude, index 1 = Longitude
    func getNearbyAPStationCoor(index: Int)-> Array<Double> {
        // Safety
        if (index >= (neighborPWStations?.count)!){
            return Array<Double>()
        }
        
        var result: Array<Double> = Array<Double> (repeatElement(0.0, count: 2))
        
        let stationLat = neighborPWStations?[index]["lat"] as! String
        result[0] = Double(stationLat)!
        
        let stationLon = neighborPWStations?[index]["lon"] as! String
        result[1] = Double(stationLon)!
        
        return result
    }
    
    func getTemperature(wuAddress: String)-> Float {
        var temp: Float = 0
        
        return temp
    }
}
