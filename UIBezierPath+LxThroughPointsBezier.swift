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
    func addBezierThrough(#points: [CGPoint]) {
    
        assert(points.count > 0, "You must give at least 1 point for drawing the bezier.");
        
        if points.count < 3 {
        
            switch points.count {
            
            case 1:
                addLineToPoint(points[0])
            case 2:
                addLineToPoint(points[1])
            default:
                break
            }
            return
        }
        
        var previousPoint = CGPointZero
        
        var previousCenterPoint = CGPointZero
        var centerPoint = CGPointZero
        var centerPointDistance = CGFloat()
        
        var obliqueRatio = CGFloat()
        var obliqueAngle = CGFloat()
        
        var previousControlPoint1 = CGPointZero
        var previousControlPoint2 = CGPointZero
        var controlPoint1 = CGPointZero
        
        for var i = 0; i < points.count; i++ {
        
            let pointI = points[i]
            
            if i > 0 {
                
                previousCenterPoint = CenterPointOf(currentPoint, previousPoint)
                centerPoint = CenterPointOf(previousPoint, pointI)
                
                centerPointDistance = DistanceBetween(previousCenterPoint, centerPoint)
                
                if previousCenterPoint.x != centerPoint.x {
                    
                    obliqueRatio = (centerPoint.y - previousCenterPoint.y) / (centerPoint.x - previousCenterPoint.x)
                    obliqueAngle = atan(obliqueRatio)
                }
                else {
                    obliqueAngle = CGFloat(M_PI_2)
                }
                
                previousControlPoint2 = CGPoint(x: previousPoint.x - 0.5 * contractionFactor * centerPointDistance * cos(obliqueAngle), y: previousPoint.y - 0.5 * contractionFactor * centerPointDistance * sin(obliqueAngle))
                controlPoint1 = CGPoint(x: previousPoint.x + 0.5 * contractionFactor * centerPointDistance * cos(obliqueAngle), y: previousPoint.y + 0.5 * contractionFactor * centerPointDistance * sin(obliqueAngle))
            }
            
            switch i {
            
            case 1 :
                
                addQuadCurveToPoint(previousPoint, controlPoint: previousControlPoint2)
                
            case 2 ..< points.count - 1 :
                
                addCurveToPoint(previousPoint, controlPoint1: previousControlPoint1, controlPoint2: previousControlPoint2)
                
            case points.count - 1 :
                
                addCurveToPoint(previousPoint, controlPoint1: previousControlPoint1, controlPoint2: previousControlPoint2)
                addQuadCurveToPoint(pointI, controlPoint: controlPoint1)
                
            default:
                break
            }
            
            previousControlPoint1 = controlPoint1
            previousPoint = pointI
        }
    }
}

func ControlPointForTheBezierCanThrough(#point1: CGPoint, #point2: CGPoint, #point3: CGPoint) -> CGPoint {
    
    return CGPoint(x: (2 * point2.x - (point1.x + point3.x) / 2), y: (2 * point2.y - (point1.y + point3.y) / 2));
}

func DistanceBetween(point1: CGPoint, point2: CGPoint) -> CGFloat {

    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
}

func CenterPointOf(point1: CGPoint, point2: CGPoint) -> CGPoint {

    return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
}