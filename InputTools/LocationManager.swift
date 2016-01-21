//
//  LocationManager.swift
//  CUPUSMobilBroker
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    var locationManager:CLLocationManager!
    static var location: CLLocation?
    
    override init(){
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.authorizationStatus() != .Restricted && CLLocationManager.authorizationStatus() != .Denied{
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocationManager.location = locations[0]
    }
    
}