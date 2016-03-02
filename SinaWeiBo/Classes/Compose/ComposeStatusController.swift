//
//  ComposeStatusController.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/28/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeStatusController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 主动召唤键盘
        customtext.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 主动隐藏键盘
        customtext.resignFirstResponder()
    }

    
    private func setupNav() {
        
        let titleView = ComposeTitleView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        self.navigationItem.titleView = titleView
        
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "didCompose")
        navigationItem.rightBarButtonItem?.enabled = false
    }
    
    private func setupUI() {
    
        view.addSubview(customtext)
        customtext.frame = UIScreen.mainScreen().bounds
        customtext.delegate = self;
        
        //添加表情子控制器
        addChildViewController(emoticonVc)
        customtext.inputView = emoticonVc.view
    }
    
    private var customtext:CustomTextView = CustomTextView()
    
    // MARK: - 懒加载
    // weak 相当于OC中的 __weak , 特点对象释放之后会将变量设置为nil
    // unowned 相当于OC中的 unsafe_unretained, 特点对象释放之后不会将变量设置为nil
    private lazy var emoticonVc: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) -> () in
        
        self.customtext.insertEmoticon(emoticon, font: 20)
        self.customtext.placeholderLabel.hidden = true
        self.navigationItem.rightBarButtonItem?.enabled = true

    }

    
    func dismiss() {
    
        dismissViewControllerAnimated(true, completion: nil)
        print(__FUNCTION__)
    }
    
    func didCompose() {
        
        var composeText = customtext.emoticonAttributedText()
        let path = "2/statuses/update.json"
        let params = ["access_token":AccountTools.getAccount()?.access_token! , "status": customtext.text]
        NetWorkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, JSON) -> Void in
            //            print(JSON)
            
            // 1.提示用户发送成功
            SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            // 2.关闭发送界面
            self.dismiss()
            }) { (_, error) -> Void in
                print(error)
                // 3.提示用户发送失败
                SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
        }

        print(__FUNCTION__)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ComposeStatusController:UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        customtext.placeholderLabel.hidden = textView.hasText()
        if textView.hasText() {
            
             navigationItem.rightBarButtonItem?.enabled = true
        }else {
            
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
}
