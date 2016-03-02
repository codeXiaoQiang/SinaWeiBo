//
//  EmoticonTextAttachment.swift
//  表情键盘界面布局
//
//  Created by xiaomage on 15/9/16.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    // 保存对应表情的文字
    var chs: String?
    
    /// 根据表情模型, 创建表情字符串
    class func imageText(emoticon: Emoticon, font: CGFloat) -> NSAttributedString{
        
        // 1.创建附件
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        // 设置了附件的大小
        attachment.bounds = CGRectMake(0, -4, font, font)
        
        // 2. 根据附件创建属性字符串
        return NSAttributedString(attachment: attachment)
    }
}
