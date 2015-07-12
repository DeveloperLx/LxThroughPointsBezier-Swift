//
//  PointView.swift
//  LxThroughPointsBezier-Swift
//

import UIKit

private let RADIUS: CGFloat = 5

class PointView: UIControl {

    class func aInstance() -> PointView {
        
        let aInstance = PointView(frame: CGRect(origin: CGPointZero, size: CGSize(width: RADIUS * 2, height: RADIUS * 2)))
        aInstance.layer.cornerRadius = RADIUS
        aInstance.layer.masksToBounds = true
        aInstance.backgroundColor = UIColor.magentaColor()
        aInstance.addTarget(aInstance, action: Selector("touchDragInside:withEvent:"), forControlEvents: .TouchDragInside)
        return aInstance
    }
    
    var dragCallBack = { (pointView: PointView) -> Void in }
    
    func touchDragInside(pointView: PointView, withEvent event: UIEvent) {
    
        for touch in event.allTouches()! {
        
            pointView.center = (touch as! UITouch).locationInView(superview)
            dragCallBack(self)
            return
        }        
    }
}
