//
//  UIBarButtonItem+extension.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/14/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
extension UIBarButtonItem {


    
    class func itemWithImage(imageNamed:String, highlightedImageNamed:String, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let custom:UIButton = UIButton()
        
        custom.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        custom.sizeToFit()
        custom.setBackgroundImage(UIImage(named: imageNamed), forState: UIControlState.Normal)
        custom.setBackgroundImage(UIImage(named: highlightedImageNamed), forState: UIControlState.Highlighted)
        let customItem:UIBarButtonItem = UIBarButtonItem(customView: custom)
        
        return customItem
    }
    
    class func itemWithTitle(title:String, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        
        let customBtn = UIButton()
        //custom.frame = CGRectMake(0, 0, 65, 44);
        customBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        customBtn.setTitle(title, forState: UIControlState.Normal)
        customBtn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
      customBtn.sizeToFit()
        let customItem:UIBarButtonItem = UIBarButtonItem(customView: customBtn)
        
        return customItem
    }

}