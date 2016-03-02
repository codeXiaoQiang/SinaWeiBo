//
//  AccountModel.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/22/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class AccountModel: NSObject, NSCoding {

    /** 授权过的token*/
    var access_token:String?
    /** 过期时间*/
    var expires_in:NSNumber?
    var remind_in:NSNumber?
    /** 用户id*/
    var uid:String?
    /** 用户名字*/
    var screen_name:String?
    /** 用户头像*/
    var avatar_large:String?
    
 //   override init() {
//        
//    }
//    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    //是否缺少成员属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
//    init(dict: NSDictionary) {
//        
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
//        screen_name = dict["screen_name"] as? String
//        avatar_large = dict["avatar_large"] as? String
//    }
    
    //账户信息归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder .encodeObject(access_token, forKey: "access_token")
        aCoder .encodeObject(expires_in, forKey: "expires_in")
        aCoder .encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(remind_in, forKey: "remind_in")

    }
    //账户信息解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        remind_in = aDecoder.decodeObjectForKey("remind_in") as? NSNumber
    }
    
    //打印出字典
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid", "avatar_large", "screen_name","remind_in"]//
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        print(dict)
        return "\(dict)"
    }

}
