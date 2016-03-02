//
//  BaseViewController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/14/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController , LoginViewDelegate{

    //保存loginview的对象
    var baseLoginView:LoginView?
    
    //是否登陆
    var isShowLogin:Bool = AccountTools.isLogin()
    override func loadView() {

        isShowLogin ? super.loadView() : setupVisitorView()
    }
    
    private func setupVisitorView() {
        
        let baseView = LoginView()
        baseView.delegate = self
        view = baseView
        baseLoginView = baseView
        
        //初始化导航条
        setupNav()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func setupNav() {
        let leftItem:UIBarButtonItem = UIBarButtonItem.itemWithTitle("登录", target: self, action: "loginClick")
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem:UIBarButtonItem = UIBarButtonItem.itemWithTitle("注册", target: self, action: "registerClick")
        navigationItem.rightBarButtonItem = rightItem
    }
    
    //MARK:-登录
    func loginClick() {
        
        didLeftBtnClick()
    }
    //MARK:-注册
    func registerClick() {
        
      
        didRightBtnClick()
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-LoginViewDelegate代理
    func didLeftBtnClick() {
        
       let oauthVc = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func didRightBtnClick() {
      
       print("注册")
    }
}
