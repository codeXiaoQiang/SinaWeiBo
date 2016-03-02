//
//  UITextView+Category.swift
//  表情键盘界面布局
//
//  Created by xiaomage on 15/9/16.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit


extension CustomTextView
{
    func insertEmoticon(emoticon: Emoticon, font: CGFloat)
    {
        
        // 0.处理删除按钮
        if emoticon.isRemoveButton
        {
            deleteBackward()
        }
        
        // 1.判断当前点击的是否是emoji表情
        if emoticon.emojiStr != nil{
            self.replaceRange(self.selectedTextRange!, withText: emoticon.emojiStr!)
        }
        
        // 2.判断当前点击的是否是表情图片
        if emoticon.png != nil{
            
            // 1.创建表情字符串
            let imageText = EmoticonTextAttachment.imageText(emoticon, font: font)
            
            
            // 3.拿到当前所有的内容
            let strM = NSMutableAttributedString(attributedString: self.attributedText)
            
            // 4.插入表情到当前光标所在的位置
            let range = self.selectedRange
            strM.replaceCharactersInRange(range, withAttributedString: imageText)
            
            // 属性字符串有自己默认的尺寸
            strM.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(font - 1), range: NSMakeRange(range.location, 1))
            
            // 5.将替换后的字符串赋值给UITextView
            self.attributedText = strM
            // 恢复光标所在的位置
            // 两个参数: 第一个是指定光标所在的位置, 第二个参数是选中文本的个数
            self.selectedRange = NSMakeRange(range.location + 1, 0)
            
        }
    }
    
    /**
    获取需要发送给服务器的字符串
    */
    func emoticonAttributedText() -> String
    {
        var strM = String()
        // 后去需要发送给服务器的数据
        attributedText.enumerateAttributesInRange( NSMakeRange(0, attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (objc, range, _) -> Void in
            
            if objc["NSAttachment"] != nil
            {
                // 图片
                let attachment =  objc["NSAttachment"] as! EmoticonTextAttachment
                strM += attachment.chs!
            }else
            {
                // 文字
                strM += (self.text as NSString).substringWithRange(range)
            }
        }
        return strM
    }
}