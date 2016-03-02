//
//  Extension+UIColor.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/25/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
extension UIColor
{
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber() , alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        // 0 ~ 255
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}