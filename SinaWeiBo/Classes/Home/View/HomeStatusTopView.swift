//
//  HomeStatusTopView.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/23/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class HomeStatusTopView: UIView {

    //获取数据
    var model:StatusModel? {
        didSet {
            //拿到模型给属性赋值
            let url = NSURL(string: (model?.user?.profile_image_url)!)
            headImageView.sd_setImageWithURL(url, placeholderImage: nil, completed: { (image, error, SDImageCacheType, NSURL) -> Void in
            })
            
            /**
            昵称
            */
            nameLab.text = model?.user?.name
            
            /**
            会员等级
            */
            leverView.image = model?.user?.leverImage
            
            /**
            认证图片
            */
            verifiedImage.image = model?.user?.verifiedImage
            
            /**
            微博来源
            */
            fromeLabel.text = model?.source
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化ui
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func setupUI() {
    
        addSubview(headImageView)
        addSubview(verifiedImage)
        addSubview(leverView)
        addSubview(nameLab)
        addSubview(fromeLabel)
    
   
        //头像
        headImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(50)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
        }
        
        //认证图标
        verifiedImage.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(14)
            make.left.equalTo(headImageView.snp_left).offset(35);
            make.top.equalTo(headImageView.snp_top).offset(35);
        }
        
        //名字
        nameLab.snp_makeConstraints { (make) -> Void in
            
            make.height.equalTo(20)
            make.left.equalTo(headImageView).offset(50 + 10)
            make.top.equalTo(self).offset(10)
        }
        
        //会员等级
        leverView.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(14)
            make.left.equalTo(nameLab.snp_right).offset(5)
            make.top.equalTo(nameLab.snp_top)
        }
        
        //来源
        fromeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(headImageView).offset(50 + 10)
            make.height.equalTo(10)
            make.bottom.equalTo(nameLab).offset(15)
            make.right.equalTo(self).offset(-20)
        }

    }
    
    //头像
    lazy var headImageView:UIImageView = {
        
        let headImageView = UIImageView()
        headImageView.layer.cornerRadius = 25
        headImageView.layer.masksToBounds = true
        
        return headImageView
    }()
    
    //名字
    lazy var nameLab:UILabel = {
        
        let nameLab = UILabel()
        nameLab.textColor = UIColor.orangeColor()
        nameLab.font = UIFont.systemFontOfSize(14)
        
        return nameLab
    }()
    
    //会员等级
    
    lazy var leverView:UIImageView = {
        
        let leverView = UIImageView()
        leverView.image = UIImage(named: "common_icon_membership")
        return leverView
    }()
    
    //认证图标
    lazy var verifiedImage:UIImageView = {
        //设置默认图标
        let verifiedImage = UIImageView()
        verifiedImage.image = UIImage(named: "avatar_enterprise_vip")
        
        return verifiedImage
    }()
    
    //来源
    lazy var fromeLabel:UILabel = {
        
        let fromeLabel = UILabel()
        fromeLabel.textColor = UIColor.lightGrayColor()
        fromeLabel.font = UIFont.systemFontOfSize(12)
        return fromeLabel
    }()

}
