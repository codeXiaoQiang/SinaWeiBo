//
//  NetWorkTools.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/22/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import AFNetworking
class NetWorkTools: AFHTTPSessionManager {

    static let tools:NetWorkTools = {
        // 注意: baseURL一定要以/结尾
        let url = NSURL(string: "https://api.weibo.com/")
        let t = NetWorkTools(baseURL: url)
        
        // 设置AFN能够接收得数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        return t
    }()
    
    // 获取单粒的方法
    class func shareNetworkTools() -> NetWorkTools {
        return tools
    }

}
