//
//  ComposeTitleView.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/28/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class ComposeTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 3.添加中间视图
        addSubview(label1)
        addSubview(label2)
    }
    
    private var label1:UILabel = {
        
       let label1 = UILabel()
        label1.text = "发送微博"
        label1.font = UIFont.systemFontOfSize(15)
        label1.sizeToFit()
        
        return label1
    }()
    
    private var label2:UILabel = {
        
       let label2 = UILabel()
        label2.text = AccountTools.getAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(15)
        label2.sizeToFit()
        
         return label2
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label1.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: self, size: nil)
        label2.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: self, size: nil)

    }
}
