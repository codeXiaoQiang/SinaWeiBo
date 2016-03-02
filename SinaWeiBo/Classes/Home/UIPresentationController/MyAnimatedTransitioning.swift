//
//  MyAnimatedTransitioning.swift
//  SinaWeiBo
//
//  Created by yangtao on 1/17/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class MyAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresented:Bool = false
    
        func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
            
            return 0.25
        }
        
        
        func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            
            
            if isPresented {
                
                var toView:UIView
                if #available(iOS 8.0, *) {
                    toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
                } else {
                    return
                }
                
                toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
                // 设置锚点
                let point = CGPointMake(0.5, 0)
                toView.layer.anchorPoint = point
                print(toView.layer.anchorPoint)
                print(toView.frame)
                
                // 2.执行动画
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                    // 2.1清空transform
                    toView.transform = CGAffineTransformIdentity
                    }) { (_) -> Void in
                        // 2.2动画执行完毕, 一定要告诉系统
                        transitionContext.completeTransition(true)
                }
            }else {
                
                var fromView:UIView
                if #available(iOS 8.0, *) {
                    fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
                } else {
                    return
                }
                
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                    
                    // 压扁
                    fromView.transform = CGAffineTransformMakeScale(1.0, 0.0000001)
                    }, completion: { (_) -> Void in
                        // 如果不写, 可能导致一些未知错误
                        transitionContext.completeTransition(true)
                })
            }
        }
  }
