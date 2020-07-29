//
//  UIBezierPath+LxThroughPointsBezier.swift
//  LxThroughPointsBezier-Swift
//

import Foundation
import UIKit

private var _contractionFactor: CGFloat = 0.7

extension UIBezierPath {
    
    /// The curve‘s bend level. The good value is about 0.6 ~ 0.8. The default and recommended value is 0.7.
    var contractionFactor: CGFloat {
        get {
            return _contractionFactor
        }
        set {
            _contractionFactor = max(0, newValue)
        }
    }
    
    /**
        @param: points Points your bezier wants to through. You must give at least 1 point (different from current point) for drawing curve.
    */
    func addBezierThrough(points: [CGPoint]) {
    
        assert(points.count > 0, "You must give at least 1 point for drawing the bezier.");
        
        if points.count < 3 {
        
            switch points.count {
            
            case 1:
                addLine(to: points[0])
            case 2:
                addLine(to: points[1])
            default:
                break
            }
            return
        }
        
        var previousPoint = CGPoint.zero
        
        var previousCenterPoint = CGPoint.zero
        var centerPoint = CGPoint.zero
        var centerPointDistance = CGFloat()
        
        var obliqueAngle = CGFloat()
        
        var previousControlPoint1 = CGPoint.zero
        var previousControlPoint2 = CGPoint.zero
        var controlPoint1 = CGPoint.zero
        
        for i in 0 ..< points.count {
        
            let pointI = points[i]
            
            if i > 0 {
                
                previousCenterPoint = CenterPointOf(point1: currentPoint, point2: previousPoint)
                centerPoint = CenterPointOf(point1: previousPoint, point2: pointI)
                
                centerPointDistance = DistanceBetween(point1: previousCenterPoint, point2: centerPoint)

                obliqueAngle = ObliqueAngleOfStraightThrough(point1:centerPoint, point2:previousCenterPoint)
                
                previousControlPoint2 = CGPoint(x: previousPoint.x - 0.5 * contractionFactor * centerPointDistance * cos(obliqueAngle), y: previousPoint.y - 0.5 * contractionFactor * centerPointDistance * sin(obliqueAngle))
                controlPoint1 = CGPoint(x: previousPoint.x + 0.5 * contractionFactor * centerPointDistance * cos(obliqueAngle), y: previousPoint.y + 0.5 * contractionFactor * centerPointDistance * sin(obliqueAngle))
            }
            
            switch i {
            
            case 1 :
                
                addQuadCurve(to: previousPoint, controlPoint: previousControlPoint2)
                
            case 2 ..< points.count - 1 :
                
                addCurve(to: previousPoint, controlPoint1: previousControlPoint1, controlPoint2: previousControlPoint2)
                
            case points.count - 1 :
                
                addCurve(to: previousPoint, controlPoint1: previousControlPoint1, controlPoint2: previousControlPoint2)
                addQuadCurve(to: pointI, controlPoint: controlPoint1)
                
            default:
                break
            }
            
            previousControlPoint1 = controlPoint1
            previousPoint = pointI
        }
    }
}

func ObliqueAngleOfStraightThrough(point1: CGPoint, point2: CGPoint) -> CGFloat {    //  [-π/2, 3π/2)

    var obliqueRatio: CGFloat = 0
    var obliqueAngle: CGFloat = 0
    
    if (point1.x > point2.x) {
        
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x)
        obliqueAngle = atan(obliqueRatio)
    }
    else if (point1.x < point2.x) {
        
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x)
        obliqueAngle = CGFloat(Double.pi) + atan(obliqueRatio)
    }
    else if (point2.y - point1.y >= 0) {
        
        obliqueAngle = CGFloat(Double.pi)/2
    }
    else {
        obliqueAngle = -CGFloat(Double.pi)/2
    }
    
    return obliqueAngle
}

func ControlPointForTheBezierCanThrough(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> CGPoint {
    
    return CGPoint(x: (2 * point2.x - (point1.x + point3.x) / 2), y: (2 * point2.y - (point1.y + point3.y) / 2));
}

func DistanceBetween(point1: CGPoint, point2: CGPoint) -> CGFloat {

    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
}

func CenterPointOf(point1: CGPoint, point2: CGPoint) -> CGPoint {

    return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
}
