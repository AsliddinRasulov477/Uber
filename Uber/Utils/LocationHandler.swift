//
//  LocationHandler.swift
//  Uber
//
//  Created by Asliddin Rasulov on 25/11/20.
//

import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    static let shared = LocationHandler()
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}
