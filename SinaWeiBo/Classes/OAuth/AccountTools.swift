//
//  AccountTools.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/22/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

let document = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
let documentsDirectory = document[0] as! NSString
let path = documentsDirectory.stringByAppendingPathComponent("account.plist") as String
class AccountTools: NSObject {

    //保存账户信息
    class func saveAccout(model:AccountModel) {
        
        NSKeyedArchiver .archiveRootObject(model, toFile: path)
    }
    
    //读取帐号信息
    static var account: AccountModel?
    class func getAccount() -> AccountModel?{
     
        if account == nil
        {
          
            account = NSKeyedUnarchiver .unarchiveObjectWithFile(path) as? AccountModel
//            let nowTime = NSDate.init()
//            let expires_Date = NSDate(timeIntervalSinceNow: (account?.expires_in!.doubleValue)!)
//            if (nowTime .compare(expires_Date)) != NSComparisonResult.OrderedDescending {
//                
//                return nil
//            }
            return account

        }
        
        return account
    }
    
    //加载用户信息
    class func loadAccountinfo(model:AccountModel, finished:(()->())) {
   
        let path = "2/users/show.json"
        let params = NSMutableDictionary(capacity: 0)
        params.setObject(model.access_token!, forKey: "access_token")
        params.setObject(model.uid!, forKey: "uid")
        NetWorkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
    
            if let dict = JSON as? [String:AnyObject] {
                
                model.avatar_large = dict["avatar_large"] as? String
                model.screen_name = dict["screen_name"] as? String
                
                finished()
//                //保存
//                self.saveAccout(model)
            }
            
            }) { (_, error) -> Void in
                print(error)

        }
    }
    
    //用户是否登录
    class func isLogin() -> Bool {
        
       return self.getAccount() != nil
    }

}
