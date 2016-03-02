//
//  OAuthViewController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/21/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import AFNetworking
class OAuthViewController: UIViewController {

    
    
//    App Key：2104069236
//    App Secret：78fbab9c8a59a41722b7a6a81d167c56
    let redirect_uri:String = "http://www.sparks.com.cn"
    let client_id:String = "2104069236"
    let AppSecret:String = "78fbab9c8a59a41722b7a6a81d167c56"
//    let redirect_uri:String = "http://www.sparks.com.cn"
//    let client_id:String = "1136373569"
//    let AppSecret:String = "7834a2353c8b58eae7fa6b0d527c45e6"
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let rightItem = UIBarButtonItem .itemWithTitle("取消", target: self, action: "dismissClick")
       navigationItem.rightBarButtonItem = rightItem
        //"https://api.weibo.com/oauth2/authorize?client_id=1136373569&redirect_uri=http://www.sparks.com.cn"
        loadVebView()
    }
    
    func dismissClick() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   private func loadVebView() {
    
        let webView = UIWebView()
        webView.delegate = self
        webView.frame =  CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        let httpString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        let url = NSURL(string: httpString)
        let webViewReq  = NSURLRequest(URL: url!)
        webView.loadRequest(webViewReq)
        webView.scalesPageToFit = true
        view.addSubview(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}

extension OAuthViewController: UIWebViewDelegate {

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(redirect_uri)
        {
            // 继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr)
        {
            // 授权成功
            // 1.取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
            
         
        }else
        {
            // 取消授权
            close()
        }
        return false
    }
    
    func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadAccessToken(code: String) {
        
        let dict = NSMutableDictionary.init(capacity: 0)
        dict.setObject(client_id, forKey: "client_id")
        dict.setObject(AppSecret, forKey: "client_secret")
        dict.setObject("authorization_code", forKey: "grant_type")
        dict.setObject(code, forKey: "code")
        dict.setObject(redirect_uri, forKey: "redirect_uri")
        let string = "oauth2/access_token"
     
        NetWorkTools.shareNetworkTools().POST(string, parameters: dict, success: { (_, JSON) -> Void in
            
                let model = AccountModel(dict: JSON as! [String : AnyObject])
                
                //加载用户数据
                AccountTools.loadAccountinfo(model, finished: { () -> () in
                    
                    //保存用户数据
                    AccountTools.saveAccout(model)
                    
                    // 去欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(switchkey, object: false)
                    
                    self.close()
            
                })
            
            }) { (_, error) -> Void in
                
             print(error)
        }
    }
    
}
