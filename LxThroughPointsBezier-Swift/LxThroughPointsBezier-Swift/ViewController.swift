//
//  ViewController.swift
//  LxThroughPointsBezier-Swift
//

import UIKit

class ViewController: UIViewController {

    let _curve = UIBezierPath()
    var _points = [CGPoint]()
    let _shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let point1 = CGPoint(x: 30, y: 210)
        let point2 = CGPoint(x: 90, y: 120)
        let point3 = CGPoint(x: 120, y: 200)
        let point4 = CGPoint(x: 160, y: 240)
        let point5 = CGPoint(x: 210, y: 160)
        let point6 = CGPoint(x: 240, y: 300)
        let point7 = CGPoint(x: 290, y: 140)
        
        drawPoint(point1)
        drawPoint(point2)
        drawPoint(point3)
        drawPoint(point4)
        drawPoint(point5)
        drawPoint(point6)
        drawPoint(point7)

        _points.append(point1)
        _points.append(point2)
        _points.append(point3)
        _points.append(point4)
        _points.append(point5)
        _points.append(point6)
        _points.append(point7)
        
        _curve.moveToPoint(point1)
        _curve.addBezierThrough(points: _points)
        
        _shapeLayer.strokeColor = UIColor.blueColor().CGColor
        _shapeLayer.fillColor = nil
        _shapeLayer.lineWidth = 3
        _shapeLayer.path = _curve.CGPath
        _shapeLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(_shapeLayer)
        
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1.4
        slider.value = 0.7
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        slider.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(slider)
        
        let sliderHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[slider]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["slider":slider])
        let sliderVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topMargin-[slider(==sliderHeight)]", options: .DirectionLeadingToTrailing, metrics: ["sliderHeight":6, "topMargin":60], views: ["slider":slider])
        
        view.addConstraints(sliderHorizontalConstraints)
        view.addConstraints(sliderVerticalConstraints)
    }
    
    func drawPoint(point: CGPoint) {
        let pointLayer = CALayer()
        pointLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        pointLayer.cornerRadius = 5
        pointLayer.position = point
        pointLayer.backgroundColor = UIColor.magentaColor().CGColor
        pointLayer.opaque = true
        view.layer.addSublayer(pointLayer)
    }
    
    func sliderValueChanged(slider: UISlider) {
    
        _curve.removeAllPoints()
        _curve.contractionFactor = CGFloat(slider.value)
        _curve.moveToPoint(_points[0])
        _curve.addBezierThrough(points: _points)
        
        _shapeLayer.path = _curve.CGPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

