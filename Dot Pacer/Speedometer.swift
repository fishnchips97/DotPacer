//
//  Speedometer.swift
//  Dot Pacer
//
//  Created by Erik Fisher on 10/15/17.
//  Copyright © 2017 GoFish. All rights reserved.
//

import Foundation
import CoreLocation

class Speedometer
{
    var measuredSpeed = 0.0
    let manager = CLLocationManager()
    var oldLocation = CLLocation()
    
    init()
    {
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.manager.requestWhenInUseAuthorization()
        }
        manager.activityType = .fitness
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func findSpeedinKm_hr() -> Double?
    {
        manager.requestLocation()
        if let newLocation = manager.location
        {
            if (!newLocation.isEqual(oldLocation))
            {
                let newSpeed = newLocation.speed
                if (newSpeed >= 0)
                {
                    measuredSpeed = newSpeed
                }
            }
            oldLocation = newLocation
            return measuredSpeed
        }
        return nil
    }
}
