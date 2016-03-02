
//
//  UIView+extension.swift
//  SinaWeiBo
//
//  Created by yangtao on 1/15/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

extension UIView {
    
    //x
    private struct AssociatedKeys_x {
        
        static var setX:CGFloat?
    }
    var setX: CGFloat? {
        get {
            
            return objc_getAssociatedObject(self, &frame.origin.x) as? CGFloat
            
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &frame.origin.x, newValue as CGFloat?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var getX: CGFloat {
        get{
            
            return frame.origin.x
        }
        
    }
    
    //y
    private struct AssociatedKeys_y {
        
        static var setY:CGFloat?
    }
    var setY: CGFloat? {
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys_y.setY) as? CGFloat
            
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys_y.setY, newValue as CGFloat?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var getY: CGFloat {
        get{
            
            return frame.origin.y
        }
        
    }
    
    //width
    private struct AssociatedKeys_width {
        
        static var setWidth:CGFloat?
    }
    var setWidth: CGFloat? {
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys_width.setWidth) as? CGFloat
            
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys_width.setWidth, newValue as CGFloat?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var getWidth: CGFloat {
        get{
            
            return frame.size.width
        }
        
    }
    
    //Height
    private struct AssociatedKeys_Height {
        
        static var setHeight:CGFloat?
    }
    var setHeight: CGFloat? {
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys_Height.setHeight) as? CGFloat
            
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys_Height.setHeight, newValue as CGFloat?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var getHeight: CGFloat {
        get{
            
            return frame.size.height
        }
    }
    
    
    //CenterX
    private struct AssociatedKeys_CenterX {
        
        static var setCenterX:CGFloat?
    }
    var setCenterX: CGFloat? {
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys_CenterX.setCenterX) as? CGFloat
            
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys_CenterX.setCenterX, newValue as CGFloat?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var getCenterX: CGFloat {
        get{
            
            return center.x
        }
    }
    
    //CenterY
    private struct AssociatedKeys_CenterY {
        
        static var setCenterY:CGFloat?
    }
    var setCenterY: CGFloat? {
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys_CenterY.setCenterY) as? CGFloat
            
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys_CenterY.setCenterY, newValue as CGFloat?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var getCenterY: CGFloat {
        get{
            
            return center.y
        }
    }
    
    //Size
//    private struct AssociatedKeys_Size {
//        
//        static var setSize:CGSize?
//    }
//    var setSize: CGSize? {
//        get {
//            
//            return objc_getAssociatedObject(self, &AssociatedKeys_Size.setSize) as? CGSize
//            
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, &AssociatedKeys_Size.setSize, newValue as CGSize?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
//    var getSize: CGSize {
//        get{
//            
//            return frame.size
//        }
//    }





    
    
    
    
//       var x: CGFloat? {
//        get {
//             return frame.origin.x
//           // return objc_getAssociatedObject(self, &frame.origin.x) as? CGFloat
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &frame.origin.x,
//                    newValue as CGFloat?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
//
//    var y: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &frame.origin.y) as? CGFloat
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &frame.origin.y,
//                    newValue as CGFloat?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
//    
//    var width: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &frame.size.width) as? CGFloat
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &frame.size.width,
//                    newValue as CGFloat?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
//    
//    var height: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &frame.size.height) as? CGFloat
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &frame.size.height,
//                    newValue as CGFloat?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
//    
//    var centerX: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &center.x) as? CGFloat
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &center.x,
//                    newValue as CGFloat?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
//    
//    var  centerY: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &center.y) as? CGFloat
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &center.y,
//                    newValue as CGFloat?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
    
//    var  size: CGSize? {
//        get {
//            return objc_getAssociatedObject(self, &frame.size) as? CGSize
//        }
//        set {
//            if let newValue:CGSize = newValue {
//                objc_setAssociatedObject(
//                    self,
//                    &frame.size,
//                    newValue as CGSize?,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                )
//            }
//        }
//    }
    
//    var  origin: CGPoint? {
//        get {
//            return objc_getAssociatedObject(self, &frame.origin) as? CGPoint
//        }
//        set {
//            if let newValue = newValue {
//                
//                objc_setAssociatedObject(
//                    self,
//                    &frame.origin,
//                    newValue as! AnyObject,
//                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//                    
//                )
//            }
//        }
//    }


    
//
//    var y: CGFloat {
//  
//        return frame.origin.y
//    }
//    
//    var width: CGFloat {
//
//        return frame.size.width
//    }
//    
//    var height: CGFloat {
//
//        return frame.size.width
//    }
//    
//    var size: CGSize {
//
//        return frame.size
//    }
//    
//    var origin: CGPoint {
//
//        return frame.origin
//    }
//    
//    var centerX:CGFloat {
//        
//        return center.x
//    }
//    
//    var centerY:CGFloat {
//        
//        return center.y
//    }
}
