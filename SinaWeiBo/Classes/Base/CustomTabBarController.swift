//
//  CustomTabBarController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/12/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
        //初始化控制器
        setupController()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //添加加号按钮
        tabBar.addSubview(addBtn)
    }
    
    //懒加载
    private lazy var addBtn:UIButton = {
    
        var btn = UIButton()
        
        let width = ScreenWidth/5
        let rect:CGRect = CGRectMake(0, 0, width, 46)
        btn.frame = rect
        btn.frame.offsetInPlace(dx:2*width, dy: 0)
        
        btn .setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: "addClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    //MARK:- 发微博动态
    func addClick() {
    
        let composeVc = ComposeStatusController()
        let customVc = CustomNavController(rootViewController:composeVc)
        presentViewController(customVc, animated: true, completion: nil)
        
        print(__FUNCTION__)
    }
    
    private func setupController()
    {
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        if let jsonPath = path{
            
             let jsonData = NSData(contentsOfFile: jsonPath)
            do{
                let arry = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                //遍历数组
                for dict in arry as! [[String: String]]
                {
                    addOneChildVc(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!, selectedImageName:"")
                }
                
            }catch{
                
                print(error)
                addOneChildVc("HomeViewController", title: "首页", imageName: "tabbar_home", selectedImageName: "tabbar_home_selected")
                
                addOneChildVc("MessageViewController", title: "消息", imageName: "tabbar_message_center", selectedImageName: "tabbar_message_center_selected")
                
                addOneChildVc("DiscoverViewController", title: "发现", imageName: "tabbar_discover", selectedImageName: "tabbar_discover_selected")
                
                addOneChildVc("MeViewController", title: "我的", imageName: "tabbar_profile", selectedImageName: "tabbar_profile_selected")
            }

        }
    }
    
    func addOneChildVc(childVcName:String,title:String, imageName:String, selectedImageName:String) {
        
        //透明度
        tabBar.translucent = false
        
        //选中色
        tabBar.tintColor = UIColor.orangeColor()
        
        //背景色
        tabBar.barTintColor = UIColor.whiteColor()
        
        //把类名转换成类
        var childVc = UIViewController()
        if  let appName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String?
        {
            let classStringName = appName!+"."+childVcName
          
            let aClass = NSClassFromString(classStringName) as! UIViewController.Type
            childVc = aClass.init()
        }

        //设置标题
        childVc.title = title;
        
        //设置图片
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        
       //设置tabBarItem的默认文字的颜色
        let dict_normal = NSMutableDictionary(objects: [UIColor.blackColor(), UIFont.systemFontOfSize(10)], forKeys: [NSForegroundColorAttributeName, NSFontAttributeName]) as NSDictionary
        childVc.tabBarItem.setTitleTextAttributes(dict_normal as? [String : AnyObject], forState: UIControlState.Normal)
        
         //设置tabBarItem的选中文字的颜色
        let dict_Selected = NSMutableDictionary(objects: [UIColor.orangeColor(), UIFont.systemFontOfSize(10)], forKeys: [NSForegroundColorAttributeName, NSFontAttributeName]) as NSDictionary
        childVc.tabBarItem.setTitleTextAttributes(dict_Selected as? [String : AnyObject], forState: UIControlState.Selected)
        
        let customVc = CustomNavController(rootViewController:childVc)
        self.addChildViewController(customVc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
