//
//  WelComeViewController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/25/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SnapKit
class WelComeViewController: UIViewController {

    
    var topCons:Constraint?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupChildView()
      
    }
    
    override func viewWillAppear(animated: Bool) {
        
       bgImageView.snp_makeConstraints { (make) -> Void in
        
            make.center.equalTo(self.view)
        }
        
        headImageView.snp_makeConstraints { (make) -> Void in
            
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.left.equalTo(self.view.snp_centerX).offset(-50)
     

            //获取顶部约束
           self.topCons = make.top.equalTo(self.view.snp_top).offset(90).constraint
            
        }
        
        textMessage.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(headImageView).offset(40)

            make.width.equalTo(160)
            make.height.equalTo(20)
        }
        
              startAnimation()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
            //startAnimation()
        
    }
    
    private func setupChildView() {
        
        view.addSubview(bgImageView)
        view.addSubview(headImageView)
        view.addSubview(textMessage)
    }
    
    private lazy var headImageView:UIImageView =  {
        
        let headImageView = UIImageView()
        headImageView.layer.cornerRadius = 50
        headImageView.layer.masksToBounds = true

        let defaultHead = UIImage(named: "avatar_default_big")
        let urlString = AccountTools.getAccount()?.avatar_large
        if urlString == nil {
            headImageView.image = defaultHead
        }else {
        
            let url = NSURL(string: urlString!)
            headImageView.sd_setImageWithURL(url, placeholderImage: defaultHead, completed: { (image, error, SDImageCacheType, NSURL) -> Void in
                
                
            })
        }
        return headImageView
    }()
    
    private lazy var bgImageView:UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "ad_background")
        
        return bgImageView
    }()
    
    private lazy var textMessage:UILabel = {
       
        let textLab = UILabel()
        textLab.alpha = 0.0
        textLab.text = "WelCome Back"
        textLab.textAlignment = NSTextAlignment.Center
        return textLab
    }()

    private func startAnimation() {
      
        UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue:0), animations: { () -> Void in
            
            self.topCons!.updateOffset(60)
            self.headImageView.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                //文本动画
                UIView .animateWithDuration(1.0, delay: 1, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: { () -> Void in
                    
                    self.textMessage.alpha = 1.0
                    }) { (_) -> Void in
                        
                        //进入首页
                        NSNotificationCenter.defaultCenter().postNotificationName(switchkey, object: true)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
