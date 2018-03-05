//
//  Racer.swift
//  Dot Pacer
//
//  Created by Erik Fisher on 6/7/17.
//  Copyright © 2017 GoFish. All rights reserved.
//

import UIKit

class RacerView: UIView {

    public var color: UIColor = UIColor.green
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    public var alphaValue: Float = 1
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        let actualCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let racer = UIBezierPath(
            arcCenter: actualCenter,
            radius: (bounds.width/2)-1,
            startAngle: 0,
            endAngle: CGFloat(2*Double.pi),
            clockwise: false
        )
        
        alpha = CGFloat(alphaValue)
        color.set()
        racer.fill()
        racer.stroke()
    }
 

}
