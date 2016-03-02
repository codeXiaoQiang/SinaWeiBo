//
//  AppDelegate.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/12/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
let switchkey = "switchRootController"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //注册监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchController:", name: switchkey, object: nil)
        
        window = UIWindow()
        window?.backgroundColor = UIColor.whiteColor()
        window?.frame = UIScreen.mainScreen().bounds
        
        //打印沙盒路径
        print("沙盒路径\(documentsDirectory)")
        print("用户信息\(AccountTools.getAccount())")
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        let isShowNew = showNewfeatureController()
        let isLogin = AccountTools.getAccount()
        
        if (isLogin != nil) {//已经登录
        
            if isShowNew {// 是否展示新特性
                window?.rootViewController = NewFeatureController()
            }else {
                window?.rootViewController =  WelComeViewController()
            }
            
        }else {
            
              window?.rootViewController =  CustomTabBarController()
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
     func switchController(notify:NSNotification) {
    
        if notify.object as! Bool {
        
            window?.rootViewController = CustomTabBarController()
        }else {
        
             window?.rootViewController = WelComeViewController()
        }
    }
    
    //销毁监听器
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
  private  func showNewfeatureController() -> Bool {
        
        //if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
       let versionKey = "CFBundleShortVersionString"
        
        //获得当前的版本号
        let currentVersion =   NSBundle.mainBundle().infoDictionary![versionKey] as! String

        //从沙盒中取出上次存储的版本号
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastVersion = defaults.objectForKey(versionKey) as? String ?? ""

    print("currentVersion = \(currentVersion)")
        print("lastVersion = \(lastVersion)")
    
        if currentVersion != lastVersion {
            
            //存储新的版本号
            defaults.setObject(currentVersion, forKey: versionKey)
            return true
        }else {
            
            return false
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

