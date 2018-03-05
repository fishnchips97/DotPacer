//
//  ViewController.swift
//  Dot Pacer
//
//  Created by Erik Fisher on 12/10/16.
//  Copyright © 2016 GoFish. All rights reserved.
//

import UIKit
import CoreLocation

class TrackViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet var track: TrackView!
    
    
    var startTime = NSDate()
    var endTime = NSDate()
    
    var timePassed: Double
    {
        get
        {
            return endTime.timeIntervalSince(startTime as Date)
        }
    }
    
    let racer = Racer(racerType: .racer)
    let pacer = Racer(racerType: .pacer)
    

    
    @IBAction func speedUp(_ sender: Any)
    {
        endTime = NSDate()
        racer.speed += 1
        track.changeSpeed(racer: racer, timeElapsed: timePassed)
        startTime = NSDate()
    }
    
    @IBAction func slowDown(_ sender: Any)
    {
        endTime = NSDate()
        racer.speed -= 1
        track.changeSpeed(racer: racer, timeElapsed: timePassed)
        startTime = NSDate()
    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    @IBAction func Start(_ sender: UIButton)
    {
        
        racer.speed = 1
        pacer.speed = 4.47
        
        startTime = NSDate()
        track.startLap(racer)
        track.startLap(pacer)
        
        
    }
    
    @IBAction func Pause(_ sender: Any)
    {
        endTime = NSDate()
        track.pause(racer: racer, timeElapsed: timePassed)
        track.pause(racer: pacer)
    }
    
    @IBAction func Resume(_ sender: Any)
    {
        track.resume(racer: racer)
        track.resume(racer: pacer)
        startTime = NSDate()
    }
    

    let speedometer = Speedometer()
    
    @IBOutlet weak var currentPaceLabel: UILabel!
    

    
    @IBAction func updateSpeed(_ sender: Any)
    {
        
        // update every 0.5 seconds
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true)
        {
            (timer) in
            self.currentPaceLabel.text = "\(self.speedometer.findSpeedinKm_hr() ?? 0.0) km/hr"
        }
        
        
    }
    
    
    
    
}


