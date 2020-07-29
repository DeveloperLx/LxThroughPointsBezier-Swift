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
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        let sliderHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[slider]-|", options: .directionLeadingToTrailing, metrics: nil, views: ["slider":slider])
        let sliderVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[slider(==sliderHeight)]", options: .directionLeadingToTrailing, metrics: ["sliderHeight":6, "topMargin":60], views: ["slider":slider])
        
        view.addConstraints(sliderHorizontalConstraints)
        view.addConstraints(sliderVerticalConstraints)
        
        var pointArray = [CGPoint]()
        
        for i in 0 ..< 6 {
        
            let pointView = PointView.aInstance()
            pointView.center = CGPoint(x: i * 60 + 30, y: 420)
            pointView.dragCallBack = { [unowned self] (pointView: PointView) -> Void in
            
                self.sliderValueChanged(slider: slider)
            }
            view.addSubview(pointView)
            _pointViewArray.append(pointView)
            
            pointArray.append(pointView.center)
        }
        
        _curve.move(to: _pointViewArray.first!.center)
        _curve.addBezierThrough(points: pointArray)
        
        _shapeLayer.strokeColor = UIColor.blue.cgColor
        _shapeLayer.fillColor = nil
        _shapeLayer.lineWidth = 3
        _shapeLayer.path = _curve.cgPath
        _shapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(_shapeLayer)
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
    
        _curve.removeAllPoints()
        _curve.contractionFactor = CGFloat(slider.value)
        
        _curve.move(to: _pointViewArray.first!.center)
        
        var pointArray = [CGPoint]()
        for pointView in _pointViewArray {
        
            pointArray.append(pointView.center)
        }
        _curve.addBezierThrough(points: pointArray)
        
        _shapeLayer.path = _curve.cgPath
    }
}

