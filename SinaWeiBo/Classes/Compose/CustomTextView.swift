//
//  CustomTextView.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/28/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
class CustomTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderLabel.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.left.equalTo(self.snp_left).offset(5)
            make.top.equalTo(self.snp_top).offset(5)
        }
    }
    
}

