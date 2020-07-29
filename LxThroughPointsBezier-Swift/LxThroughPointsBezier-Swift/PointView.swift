//
//  PointView.swift
//  LxThroughPointsBezier-Swift
//

import UIKit

private let RADIUS: CGFloat = 5

class PointView: UIControl {

    class func aInstance() -> PointView {
        
        let aInstance = PointView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: RADIUS * 2, height: RADIUS * 2)))
        aInstance.layer.cornerRadius = RADIUS
        aInstance.layer.masksToBounds = true
        aInstance.backgroundColor = UIColor.magenta
        aInstance.addTarget(aInstance, action: #selector(touchDragInside(pointView:withEvent:)), for: .touchDragInside)
        return aInstance
    }
    
    var dragCallBack = { (pointView: PointView) -> Void in }
    
    @objc func touchDragInside(pointView: PointView, withEvent event: UIEvent) {
    
        for touch in event.allTouches! {
        
            pointView.center = touch.location(in: superview)
            dragCallBack(self)
            return
        }        
    }
}
