//
//  CustomBottomView.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/27/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit


class CustomBottomView: UIView {
    
    var model:StatusModel? {
        didSet {
            
            /**
            微博转发,评论,点赞数
            */
            reposts_count = (model?.reposts_count)!
            comments_count = (model?.comments_count)!
            attitudes_count = (model?.attitudes_count)!
        }
    }

    var reposts_count:Int = 0 {
        didSet {
            leftButton.setTitle("\(reposts_count)", forState: UIControlState.Normal)
        }
    }
    var comments_count:Int = 0 {
    
        didSet {
            centerButton.setTitle("\(comments_count)", forState: UIControlState.Normal)
        }
    }
    var attitudes_count:Int = 0 {
    
        didSet {
            rightButton.setTitle("\(attitudes_count)", forState: UIControlState.Normal)
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backView)
        addSubview(leftButton)
        addSubview(leftlineView)
        addSubview(centerButton)
        addSubview(rightlineView)
        addSubview(rightButton)
    }
    
    private lazy var backView:UIImageView = {
        
        let backView = UIImageView()
        backView.image = UIImage(named: "timeline_card_bottom_background")
        return backView
    }()
    
    private lazy var leftButton:UIButton = {
    
            let leftButton = UIButton.setButton("timeline_icon_retweet", title: "\(self.reposts_count)", font: 14, color: UIColor.lightGrayColor())
            leftButton.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0)
            
            return leftButton
    }()
    
    private lazy var leftlineView:UIImageView = {
        
        let leftlineView = UIImageView()
        leftlineView.image = UIImage(named: "timeline_card_bottom_line_highlighted")
        return leftlineView
    }()


    private lazy var centerButton:UIButton = {
        
        let centerButton = UIButton.setButton("timeline_icon_comment", title: "\(self.comments_count)", font: 14, color: UIColor.lightGrayColor())
        centerButton.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0)

        
        return centerButton
    }()
    
    private lazy var rightlineView:UIImageView = {
        
        let rightlineView = UIImageView()
         rightlineView.image = UIImage(named: "timeline_card_bottom_line_highlighted")
        return rightlineView
    }()

    

    private lazy var rightButton:UIButton = {
        
        let rightButton = UIButton.setButton("timeline_icon_unlike", title:"\(self.attitudes_count)", font: 14, color: UIColor.redColor())
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0)
        rightButton.setImage(UIImage(named: "timeline_icon_like"), forState: UIControlState.Highlighted)
        rightButton.addTarget(self, action: "clickLike", forControlEvents: UIControlEvents.TouchUpInside)
        
        return rightButton
    }()
    
    func clickLike() {
        
        print(__FUNCTION__)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(0)
        }
        
        leftButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(ScreenWidth/3)
            make.height.equalTo(40)
            make.left.top.equalTo(0)
        }
        
        leftlineView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(1)
            make.height.equalTo(20)
            make.left.equalTo(leftButton.snp_right).offset(0)
            make.top.equalTo(10)
        }
        
        centerButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(ScreenWidth/3)
            make.height.equalTo(40)
            make.left.equalTo(leftButton.snp_right).offset(0)
            make.top.equalTo(0)
        }
        
        rightlineView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(1)
            make.height.equalTo(20)
            make.left.equalTo(centerButton.snp_right).offset(0)
            make.top.equalTo(10)
        }

        
        rightButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(ScreenWidth/3)
            make.height.equalTo(40)
            make.left.equalTo(centerButton.snp_right).offset(0)
            make.top.equalTo(0)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
