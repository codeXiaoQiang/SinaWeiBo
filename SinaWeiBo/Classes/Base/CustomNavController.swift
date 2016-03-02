//
//  CustomNavController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/12/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航条的背景颜色
        /*
        navigationBar.barTintColor = UIColor.orangeColor()
        navigationBar.translucent = false
*/
        interactivePopGestureRecognizer!.delegate = self;

    }
    
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = false
           viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithImage("tabbar_compose_background_icon_return", highlightedImageNamed: "tabbar_compose_background_icon_return", target: self, action: "back")
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func back() {
        
        popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

extension CustomNavController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return viewControllers.count > 1
    }
}

