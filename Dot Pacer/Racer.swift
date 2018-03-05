//
//  Racer.swift
//  Dot Pacer
//
//  Created by Erik Fisher on 6/12/17.
//  Copyright © 2017 GoFish. All rights reserved.
//

import Foundation
import CoreLocation

class Racer
{
    // units are m/s; 1 m/s for 400 seconds translates to 400m or 1 lap
    var speed: Double = CLLocationSpeed()
    {
        willSet
        {
            lastSpeed = speed
        }
    }
    var lastSpeed: Double = 0
    var typeOfRacer = racerType.racer
    
    enum racerType
    {
        case racer
        case pacer
    }
    
    func getGPSSpeed()
    {
        speed = CLLocationSpeed()
    }
    
    init(racerType: racerType = .racer)
    {
        switch racerType
        {
        case .racer:
            typeOfRacer = .racer
        case .pacer:
            typeOfRacer = .pacer
        }
    }
    
    private var distanceRun = 0.0
    
    func distanceFrom(racer: Racer) -> Double
    {
        return Swift.abs(self.distanceRun - racer.distanceRun)
    }
    
}
