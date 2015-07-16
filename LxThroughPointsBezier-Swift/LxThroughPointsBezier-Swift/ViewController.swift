//
//  ViewController.swift
//  LxThroughPointsBezier-Swift
//

import UIKit

class ViewController: UIViewController {

    let _curve = UIBezierPath()
    let _shapeLayer = CAShapeLayer()
    var _pointViewArray = [PointView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1.4
        slider.value = 0.7
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        view.addSubview(slider)
        
        slider.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let sliderHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[slider]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["slider":slider])
        let sliderVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topMargin-[slider(==sliderHeight)]", options: .DirectionLeadingToTrailing, metrics: ["sliderHeight":6, "topMargin":60], views: ["slider":slider])
        
        view.addConstraints(sliderHorizontalConstraints)
        view.addConstraints(sliderVerticalConstraints)
        
        var pointArray = [CGPoint]()
        
        for i in 0 ..< 6 {
        
            let pointView = PointView.aInstance()
            pointView.center = CGPoint(x: i * 60 + 30, y: 420)
            pointView.dragCallBack = { [unowned self] (pointView: PointView) -> Void in
            
                self.sliderValueChanged(slider)
            }
            view.addSubview(pointView)
            _pointViewArray.append(pointView)
            
            pointArray.append(pointView.center)
        }
        
        _curve.moveToPoint(_pointViewArray.first!.center)
        _curve.addBezierThrough(points: pointArray)
        
        _shapeLayer.strokeColor = UIColor.blueColor().CGColor
        _shapeLayer.fillColor = nil
        _shapeLayer.lineWidth = 3
        _shapeLayer.path = _curve.CGPath
        _shapeLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(_shapeLayer)
    }
    
    func sliderValueChanged(slider: UISlider) {
    
        _curve.removeAllPoints()
        _curve.contractionFactor = CGFloat(slider.value)
        
        _curve.moveToPoint(_pointViewArray.first!.center)
        
        var pointArray = [CGPoint]()
        for pointView in _pointViewArray {
        
            pointArray.append(pointView.center)
        }
        _curve.addBezierThrough(points: pointArray)
        
        _shapeLayer.path = _curve.CGPath
    }
}

