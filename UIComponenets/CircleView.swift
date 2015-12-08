//
//  CircleView.swift
//  KSWeather
//
//  Created by Karan Shah on 12/7/15.
//  Copyright © 2015 Karan Shah. All rights reserved.
//

import UIKit

@IBDesignable
public class CircleView: UIView {

    @IBInspectable public var diameter: CGFloat = 10.0
    @IBInspectable public var color: UIColor = UIColor.blueColor()

    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let circleRect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(ctx, circleRect)
        CGContextSetFillColor(ctx, CGColorGetComponents(color.CGColor))
        CGContextFillPath(ctx)
    }
    
}
