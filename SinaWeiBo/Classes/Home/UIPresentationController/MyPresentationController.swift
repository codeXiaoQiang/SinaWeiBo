//
//  MyPresentationController.swift
//  SinaWeiBo
//
//  Created by yangtao on 1/17/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class MyPresentationController: UIPresentationController {
 
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    
//    override func frameOfPresentedViewInContainerView() -> CGRect {
//        
//        
//        let x:CGFloat = (ScreenWidth - 200)/2
//        let  rect = CGRectMake(x,64, 200, 300)
//        presentedView()?.frame = rect
//       return (presentedView()?.frame)!
//    }
    
    override func containerViewWillLayoutSubviews() {
         let x:CGFloat = (ScreenWidth - 200)/2
        presentedView()?.frame = CGRectMake(x, 64, 200, 300)
    }
    
    override func presentationTransitionWillBegin() {
    
        containerView?.addSubview(presentedView()!)
        
       containerView?.insertSubview(coverView, atIndex: 0)
    }
    override func presentationTransitionDidEnd(completed: Bool) {
    
    }
    override func dismissalTransitionWillBegin() {
    
    }
    override func dismissalTransitionDidEnd(completed: Bool) {
    
        presentedView()?.removeFromSuperview()
    }
    
    // MARK: - 懒加载
    private lazy var coverView: UIView = {
        // 1.创建view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        // 2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func close(){
        // presentedViewController拿到当前弹出的控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
