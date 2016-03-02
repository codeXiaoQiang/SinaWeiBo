//
//  LoginView.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/14/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SnapKit
// Swift中如何定义协议: 必须遵守NSObjectProtocol
protocol LoginViewDelegate :NSObjectProtocol{

    func didLeftBtnClick()
    func didRightBtnClick()
}

class LoginView: UIView {
    
  func setUpInfoLoginView(isHome:Bool, imageName:String, text:String) {
    
        circleView.hidden = !isHome
    
        houseView.image = UIImage(named: imageName)
    
        textView.text = text;

        if isHome {
            
            isStatAnimation()
        }
    
    }
    
    private func isStatAnimation() {
    
        //创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        animation.toValue = 2 * M_PI
        animation.duration = 20;
        animation.repeatCount = MAXFLOAT
        // 将动画添加到涂层上
        circleView.layer.addAnimation(animation, forKey: nil)
        
    }
    
    //申明代理属性
   weak var delegate:LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化子控件
        addSubview(houseView)
        addSubview(circleView)
        addSubview(textView)
        addSubview(loginButton)
        addSubview(registerButton)
    }
    
  required  init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //hose
        houseView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        
        //circle
        circleView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
      
        //test
        textView.snp_makeConstraints { (make) -> Void in
          
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(circleView).offset(175)
        }
        
        //login
        let margin:CGFloat = (ScreenWidth - 120-20)/2
        loginButton.snp_makeConstraints { (make) -> Void in
            
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(textView).offset(40)
        }
        
        registerButton.snp_makeConstraints { (make) -> Void in
            
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.right.equalTo(loginButton).offset(20+60)
            make.bottom.equalTo(textView).offset(40)
        }
        
    }
    
    //MARK:-定义子控件
    private lazy var houseView:UIImageView = {
    
        let houseView = UIImageView()
        
        return houseView
    }()
    

    private lazy var circleView:UIImageView = {
        
        let circleView = UIImageView()
        circleView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        
        return circleView
    }()
    

    private lazy var textView:UILabel = {
        
        let textView = UILabel()
        textView.backgroundColor = UIColor.redColor()
        //textView.text = "后可以看到最新的动态登录之后看到最新的动态登录之后后后可以看到最"
        textView.numberOfLines = 0
        
        return textView
    }()

    
   private lazy var loginButton:UIButton = {
    
       let loginBtn = UIButton()
        loginBtn.setTitle("登录", forState: UIControlState.Normal)
        loginBtn.backgroundColor = UIColor.redColor()
        loginBtn.addTarget(self, action: "left", forControlEvents: UIControlEvents.TouchUpInside)
        return loginBtn
    }()
    
    private lazy var registerButton:UIButton = {
        
        let registerBtn = UIButton()
        registerBtn.setTitle("注册", forState: UIControlState.Normal)
         registerBtn.backgroundColor = UIColor.redColor()
        registerBtn.addTarget(self, action: "right", forControlEvents: UIControlEvents.TouchUpInside)

        return registerBtn
    }()
    
    func left() {
        
        delegate?.didLeftBtnClick()
    }
    
    func right() {
        delegate?.didRightBtnClick()
    }
}
