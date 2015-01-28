# LxThroughPointsBezier-Swift
  An ideal iOS library using swift programming language. Draw a smooth curve through several points you designated. The curve‘s bend level is adjustable.
Installation
------------
  You only need drag UIBezierPath+LxThroughPointsBezier.swift to your project.
Support
------------
  Minimum support iOS version: iOS 5.0
Usage
-----------
###
        var _points = [CGPoint]()

        let point1 = CGPoint(x: 30, y: 210)
        let point2 = CGPoint(x: 90, y: 120)
        let point3 = CGPoint(x: 120, y: 200)
        let point4 = CGPoint(x: 160, y: 240)
        let point5 = CGPoint(x: 210, y: 160)
        let point6 = CGPoint(x: 240, y: 300)
        let point7 = CGPoint(x: 290, y: 140)
  
        _points.append(point1)
        _points.append(point2)
        _points.append(point3)
        _points.append(point4)
        _points.append(point5)
        _points.append(point6)
        _points.append(point7)
        
        let _curve = UIBezierPath()
        
        _curve.contractionFactor = CGFloat(0.7)
        _curve.moveToPoint(point1)
        _curve.addBezierThrough(points: _points)
        
        let _shapeLayer = CAShapeLayer()
        
        _shapeLayer.strokeColor = UIColor.blueColor().CGColor
        _shapeLayer.fillColor = nil
        _shapeLayer.lineWidth = 3
        _shapeLayer.path = _curve.CGPath
        _shapeLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(_shapeLayer)
Be careful            
-----------
    The good bend level is about 0.6 ~ 0.8. The default and recommended value is 0.7.
    You must give at least 1 point for drawing the curve.
License
-----------
AFNetworking is available under the Apache License 2.0. See the LICENSE file for more info.
