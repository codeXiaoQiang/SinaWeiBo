//
//  HomeStatusForwardCell.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/23/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class HomeStatusForwardCell: HomeStatusCell {

    // 重写父类属性的didSet并不会覆盖父类的操作
    // 注意点: 如果父类是didSet, 那么子类重写也只能重写didSet
   override var model:StatusModel? {
        didSet {
                let name = model?.retweeted_status?.user?.name ?? ""
                let text = model?.retweeted_status?.text ?? ""
                forwardContentLab.text = name + ": " + text
            }
    }

    //重新父类的初始化方法
   override func setupUI() {
        super.setupUI()
    
        //添加子控件
        contentView.insertSubview(forwardBgButton, belowSubview: pictureView)
        contentView.insertSubview(forwardContentLab, aboveSubview: forwardBgButton)
    
        //布局子控件
        forwardBgButton.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(pictureView).offset(0)
            make.top.equalTo(contentLabel.snp_bottom).offset(5)
            make.bottom.equalTo(bottomView.snp_top).offset(10)
        }
    
        //转发的正文
        forwardContentLab.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(forwardBgButton.snp_top).offset(5)
            make.left.equalTo(forwardBgButton).offset(10)
            make.right.equalTo(forwardBgButton).offset(-10)
        }
    
        //重新设置转发配图的位置
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(10)
            self.pictureTopCons =  make.top.equalTo(forwardContentLab.snp_bottom).offset(10).constraint
            self.pictureWidthCons = make.width.equalTo(0).constraint
            self.pictureHeightCons = make.height.equalTo(0).constraint
        }
    
}
    
    private lazy var forwardBgButton:UIButton = {
        let forwardBgButton = UIButton()

        forwardBgButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return forwardBgButton
    }()
    
    private lazy var forwardContentLab:UILabel = {
        let forwardContentLab = UILabel()
      
        forwardContentLab.font = UIFont.systemFontOfSize(15)
        forwardContentLab.numberOfLines = 0

        return forwardContentLab
    }()
    
    
}
