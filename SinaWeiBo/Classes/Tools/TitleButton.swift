//
//  TitleButton.swift
//  SinaWeiBo
//
//  Created by yangtao on 1/17/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
     
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)!+5
    }

}
