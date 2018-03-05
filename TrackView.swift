//
//  TrackView.swift
//  Dot Pacer
//
//  Created by Erik Fisher on 1/14/17.
//  Copyright © 2017 GoFish. All rights reserved.
//

import UIKit


@IBDesignable
class TrackView: UIView
{
    private lazy var racer: RacerView = self.createRacer(color: UIColor.green)
    private lazy var pacer: RacerView = self.createRacer(color: UIColor.red, newAlpha: 0.5)
    
    private let racerDiameter = 20
    private var racerSize = CGSize()
    
    private var track = UIBezierPath()
    
    // 400 seconds so moving a 1 m/s will travel 400m, the distance of a track
    private let defaultDuration = 400
    
    func createRacer(color: UIColor, newAlpha: Float = 1) -> RacerView
    {
        let racer = RacerView()
        racer.isOpaque = false
        racer.color = color
        racer.alphaValue = newAlpha
        self.addSubview(racer)
        return racer
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        let rectTrack = CGRect(x: bounds.width*(1/16), y: bounds.height*(1/8), width: bounds.width*(1/2), height: bounds.height*(2/3))
        let rectTrackBez = UIBezierPath(rect: rectTrack)
        
        
        let startingPointForRacers = CGPoint(
            x:rectTrackBez.bounds.maxX - CGFloat(racerDiameter/2),
            y:rectTrackBez.bounds.midY + 2.5
        )
        
        let trackStartingPoint = CGPoint(
            x:rectTrackBez.bounds.maxX,
            y:rectTrackBez.bounds.midY + CGFloat(racerDiameter/2) + 2.5
        )
        
        let trackRadius = CGFloat(rectTrack.width)*(0.5)
        
        let topRightCorner     = CGPoint(x: rectTrackBez.bounds.maxX, y: rectTrackBez.bounds.minY + trackRadius)
        let bottomLeftCorner   = CGPoint(x: rectTrackBez.bounds.minX, y: rectTrackBez.bounds.maxY - trackRadius)
        let topRectPoint = CGPoint(x: rectTrackBez.bounds.midX, y: rectTrackBez.bounds.minY + trackRadius)
        let bottomRectPoint = CGPoint(x: rectTrackBez.bounds.midX, y: rectTrackBez.bounds.maxY - trackRadius)
        
        track = UIBezierPath()
        track.move(to: trackStartingPoint)
        track.addLine(to: topRightCorner)
        track.addArc(withCenter: topRectPoint, radius: trackRadius, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        track.addLine(to: bottomLeftCorner)
        track.addArc(withCenter: bottomRectPoint, radius: trackRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(2 * Double.pi), clockwise: false)
        track.addLine(to: trackStartingPoint)
        
        track.lineWidth = 20
        UIColor.orange.set()
        track.stroke()
        
        let startingLinePoint1 = CGPoint(x: trackStartingPoint.x - 20, y: trackStartingPoint.y - CGFloat(racerDiameter/2) - 2.5)
        let startingLinePoint2 = CGPoint(x: trackStartingPoint.x + 20, y: trackStartingPoint.y - CGFloat(racerDiameter/2) - 2.5)
        let startingLine = UIBezierPath()
        startingLine.move(to: startingLinePoint1)
        startingLine.addLine(to: startingLinePoint2)
        startingLine.lineWidth = 5
        UIColor.white.set()
        startingLine.stroke()
        
        racerSize = CGSize(width: racerDiameter, height: racerDiameter)
        let startingFrame = CGRect(origin: startingPointForRacers, size: racerSize)
        racer.frame = startingFrame
        pacer.frame = startingFrame
        
    }
    
    
    
    func startLap(_ racer: Racer)
    {
        timeAdjuster = 0.0
        distanceInLaps = 0.0
        
        let raceAnimation = CAKeyframeAnimation(keyPath: "position")
        raceAnimation.duration = CFTimeInterval(defaultDuration)
        raceAnimation.path = track.cgPath
        raceAnimation.calculationMode = kCAAnimationPaced
        raceAnimation.repeatCount = Float.infinity
        raceAnimation.speed = Float(racer.speed)

        
        switch racer.typeOfRacer
        {
        case .racer:
            self.racer.layer.speed = 1.0
            self.racer.layer.timeOffset = 0.0
            self.racer.layer.beginTime = 0.0
            self.racer.layer.add(raceAnimation, forKey: "animate position along path")
        case .pacer:
            self.pacer.layer.add(raceAnimation, forKey: "animate position along path")
        }
    }
    
    var timeAdjuster: Double = 0
    var distanceInLaps: Double = 0
    
    public func changeSpeed(racer: Racer, timeElapsed: Double)
    {
//        print(racer.speed)
        if (racer.typeOfRacer == .racer)
        {
            if (racer.speed == 0.0)
            {
                pause(racer: racer, timeElapsed: timeElapsed)
                return
            }
            
            if (racer.lastSpeed == 0.0)
            {
                resume(racer: racer)
                return
            }
        }
        
        // time == (aquired distance around track + more distance)/current speed
        distanceInLaps += (timeElapsed*racer.lastSpeed)
        timeAdjuster = distanceInLaps/racer.speed
        
        let raceAnimation = CAKeyframeAnimation(keyPath: "position")
        raceAnimation.calculationMode = kCAAnimationPaced
        raceAnimation.path = track.cgPath
        raceAnimation.speed = Float(racer.speed)
        raceAnimation.duration = CFTimeInterval(defaultDuration)
        raceAnimation.beginTime = CACurrentMediaTime() - Double(timeAdjuster)
        raceAnimation.repeatCount = Float.infinity
        
        self.racer.layer.beginTime = 0.0
        
        switch racer.typeOfRacer
        {
        case .racer:
            self.racer.layer.add(raceAnimation, forKey: "animate position along path")
        case .pacer:
            self.pacer.layer.add(raceAnimation, forKey: "animate position along path")
        }
    }
    
    public func pause(racer: Racer, timeElapsed: Double = 0.0)
    {
        switch racer.typeOfRacer
        {
        case .racer:
            distanceInLaps += (timeElapsed*racer.speed)
            
            let pausedTime: CFTimeInterval = self.racer.layer.convertTime(CACurrentMediaTime(), from: nil)
            self.racer.layer.speed = 0.0
            self.racer.layer.beginTime = 0.0
            self.racer.layer.timeOffset = pausedTime
        case .pacer:
            let pausedTime = CFTimeInterval(self.pacer.layer.convertTime(CACurrentMediaTime(), from: nil))
            self.pacer.layer.speed = 0.0
            self.pacer.layer.beginTime = 0.0
            self.pacer.layer.timeOffset = pausedTime
        }
    }
    
    public func resume(racer: Racer)
    {
        
        switch racer.typeOfRacer
        {
        case .racer:
            let pausedTime: CFTimeInterval = self.racer.layer.timeOffset
            self.racer.layer.speed = 1.0
            self.racer.layer.timeOffset = 0.0
//            self.racer.layer.beginTime = 0.0
            let timeSincePause: CFTimeInterval = self.racer.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            self.racer.layer.beginTime = timeSincePause
        case .pacer:
            let pausedTime = CFTimeInterval(self.pacer.layer.timeOffset)
            self.pacer.layer.speed = 1.0
            self.pacer.layer.timeOffset = 0.0
            //        self.pacer.layer.beginTime = 0.0
            let timeSincePause = CFTimeInterval(self.pacer.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime)
            self.pacer.layer.beginTime = timeSincePause
        }
        
                
    }
        
    public func stop()
    {
        self.racer.layer.removeAllAnimations()
        self.pacer.layer.removeAllAnimations()
        timeAdjuster = 0
        distanceInLaps = 0
    }

}
