//
//  StatusModel.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/26/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SDWebImage
class StatusModel: NSObject{

 /// 创建时间
    var created_at:String?
 /// 微博id
    var id:Int = 0
 /// 微博内容
    var text:String?
 /// 微博来源
    var source:String? {
        didSet {
        
            if let str = source {
                if str != "" {
                
                    let startLocation = (str as NSString).rangeOfString(">").location + 1
                    let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                    if startLocation >= 0 && length >= 0 {
                        
                        source = "from:" + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
                    }

                }
                

            }
            
        }
    }
/// 用户配图
    var pic_urls:[[String: AnyObject]]? {
    
        didSet {
            //初始化数组
            storePic_URL = [NSURL]()
            storedLargePicURLS = [NSURL]()
            for dict in pic_urls! {
            
                if let urlString = dict["thumbnail_pic"] {
                
                    storePic_URL?.append(NSURL(string: urlString as! String)!)
                    
                    // 2.处理大图
                    let largeURLStr = urlString.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePicURLS!.append(NSURL(string: largeURLStr)!)
                }
            }
        }
        
    }
    
    /// 保存当前微博所有配图"大图"的URL
    var storedLargePicURLS: [NSURL]?
    
    /// 定义一个计算属性, 用于返回原创或者转发配图的大图URL数组
    var LargePictureURLS:[NSURL]?
        {
            return retweeted_status != nil ? retweeted_status?.storedLargePicURLS : storedLargePicURLS
    }
    
    /// 转发微博
    var retweeted_status: StatusModel?
    
    var retweetedPic_URL:[NSURL]? {
        
        return retweeted_status != nil ? retweeted_status?.storePic_URL:storePic_URL
    }
    

 /// 保存微博图像
   var storePic_URL:[NSURL]?
    
/// 用户转发
    var reposts_count:Int = 0
/// 用户评论
    var comments_count:Int = 0
/// 点赞数
    var attitudes_count:Int = 0
 /// 用户信息
    var user:User?
    
    init(dict: [String: AnyObject]) {
        
        super.init()
       //利用kcv字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if "user" == key {
            
            user = User(dict: value as! [String: AnyObject])
            return
        }
        
        // 2.判断是否是转发微博, 如果是就自己处理
        if "retweeted_status" == key
        {
            retweeted_status = StatusModel(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    //重现该方法的目的是为了防止，返回的数据与模型的属性不匹配导致程序崩溃
    //是否缺少成员属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        //print(key)
    }
    
    var property = ["created_at", "id", "text", "source", "user", "pic_ids","reposts_count","comments_count","attitudes_count"]
    override  var description: String {
        //把属性转化成字典，打印出来便于调试程序
    
        let dict = dictionaryWithValuesForKeys(property)
        
        return "\(dict)"
    }
    
    class func loadStatus(since_id:Int,max_id: Int,finished: (models:[StatusModel]?, error: NSError?)->()) {
    
        let urlString = "2/statuses/home_timeline.json"
        let params = NSMutableDictionary(capacity: 0)
        params.setValue(AccountTools.getAccount()?.access_token, forKey: "access_token")
       // var params = ["access_token": AccountTools.getAccount()!.access_token!]
        
        // 下拉刷新
        if since_id > 0
        {
            params.setValue(since_id, forKey: "since_id")
            //params["since_id"] = "\(since_id)"
        }
        
        // 上拉刷新
        if max_id > 0
        {
            params["max_id"] = "\(max_id - 1)"
        }
        
        NetWorkTools.shareNetworkTools().GET(urlString, parameters: params, success: { (_, JSON) -> Void in
        
            //遍历数组给模型赋值
            let models = dict2Model(JSON!["statuses"] as! [[String: AnyObject]])
        
            //缓存图片
            cacheStatusImages(models, finished: finished)
            
            }) { (_, error) -> Void in
                
            finished(models: nil, error: error)
        }
    }
    
    class func cacheStatusImages(lists:[StatusModel]?, finished: (models:[StatusModel]?, error: NSError?)->()) ->() {
        
        
        if lists!.count == 0
        {
            finished(models: lists, error: nil)
            return
        }
    
        // 1.创建一个组保证所有图片下载完毕
        let group = dispatch_group_create()
        
        for model in lists! {
            
            // Swift2.0新语法, 如果条件为nil, 那么就会执行else后面的语句
            //            status.storedPicURLS = nil
            guard let _ = model.retweetedPic_URL else
            {
                continue
            }
            

            for url in model.retweetedPic_URL! {
                
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    
                    // 离开当前组
                    dispatch_group_leave(group)
                })
                
            }
            
        }
        
        // 2.当所有图片都下载完毕再通过闭包通知调用者
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in

            finished(models: lists, error: nil)
        }

    }
    
    /// 将字典数组转换为模型数组
    class func dict2Model(list: [[String: AnyObject]]) -> [StatusModel] {
        var models = [StatusModel]()
        for dict in list
        {
            models.append(StatusModel(dict: dict))
        }
        return models
    }

   
}
