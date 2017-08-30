//
//  Pin.swift
//  WeatherStations
//
//  Created by Yvonne Yeung on 8/29/17.
//  Copyright © 2017 Yvonne Yeung. All rights reserved.
//

import Foundation
import MapKit



class Pin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    let annotationView: MKPinAnnotationView = MKPinAnnotationView()
    
    var title: String?
}
