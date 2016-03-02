//
//  User.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/26/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class User: NSObject {

    /// 用户id
    var id:Int = 0
     /// 用户名字
    var name:String?
     /// 用户头像
    var profile_image_url:String?

    /// 用户的认证类型
    var verified_type: Int = -1 {//-1：没有认证
      
        didSet {
        
            switch verified_type
            {
            case 0://0，认证用户
                verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5://2,3,5: 企业认证
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220://220: 达人
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
        
    }
    
 /// 会员等级
    var mbrank:Int = 0 {
    
        didSet {
        
            if mbrank > 0 && mbrank < 7 {
            
                leverImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
            
        }
    }
    
 /// 保存会员等级图标
    var leverImage: UIImage?
    
    /// 保存当前用户的认证图片
    var verifiedImage: UIImage?
    
    init(dict: [String: AnyObject]) {
        
        super.init()
        //利用kcv字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    
    //重现该方法的目的是为了防止，返回的数据与模型的属性不匹配导致程序崩溃
    //是否缺少成员属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
       // print(key)
    }
    
    var property = ["id", "name", "profile_image_url","verified_type","mbrank"]
    override  var description: String {
        //把属性转化成字典，打印出来便于调试程序
        
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }

}
