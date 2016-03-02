//
//  HomeStatusCell.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/26/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

let pictureViewCellIdentifier = "pictureViewCell"

enum StatusCellIdentifier:String {
    
    case statusCell = "statusCell"
    case forwardCell = "forwardCell"
    
    // 如果在枚举中利用static修饰一个方法 , 相当于类中的class修饰方法
    // 如果调用枚举值的rawValue, 那么意味着拿到枚举对应的原始值
    static func cellID(status: StatusModel) ->String
    {
        return status.retweeted_status != nil ? forwardCell.rawValue : statusCell.rawValue
    }

}

class HomeStatusCell: UITableViewCell {
    
    /// 保存配图的宽度约束
    var pictureWidthCons: Constraint?
    /// 保存配图的高度约束
    var pictureHeightCons: Constraint?
    var pictureTopCons: Constraint?
    var model:StatusModel? {
        didSet {
            
            /**
            顶部试图
            */
            statusTopView.model = model
            
            /**
            微博内容
            */
            contentLabel.text = model?.text

            /**
             配图
             */
            
            // 设置配图的尺寸
            pictureView.model = model?.retweeted_status != nil ? model?.retweeted_status :  model

            let size = pictureView.calculateImageSize()
            pictureWidthCons?.updateOffset(size.width)
            pictureHeightCons?.updateOffset(size.height)
            if model?.retweeted_status != nil {
                pictureTopCons?.updateOffset(10)
            }else {
                pictureTopCons?.updateOffset(-20)
            }
      
            /**
            微博转发,评论,点赞数
            */
            bottomView.model = model
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    class func cellWithTableView(tableView:UITableView, indexPath: NSIndexPath) -> (HomeStatusCell) {
    
        let identifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? HomeStatusCell
        
        if (cell == nil) {
        
            cell = HomeStatusCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化子控件
        setupUI()
    }
    
    func setupUI() {
    
        contentView.addSubview(statusTopView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        //topView
        statusTopView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(contentView).offset(0)
            make.height.equalTo(contentView).offset(60)
        }
        
        //文本
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(70)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        
//        //底部工具条
        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(pictureView).offset(0)
            make.top.equalTo(pictureView.snp_bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //topView
    lazy var statusTopView: HomeStatusTopView = {
        
        let statusTopView = HomeStatusTopView()
        return statusTopView
    }()
    
     //文本
    lazy var contentLabel:UILabel = {
        
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFontOfSize(15)
        contentLabel.numberOfLines = 0
        
        return contentLabel
    }()
    

    //配图
    lazy var pictureView:HomeStatusPictureView = {
        
       let pictureView = HomeStatusPictureView()
        
        return pictureView
    }()
    
    //底部工具条
    lazy var bottomView:CustomBottomView = {
        
        let bottomView = CustomBottomView()
        return bottomView
    }()
    
    /**
     用于获取行号
     */
    func rowHeight(status: StatusModel) -> CGFloat
    {
        // 1.为了能够调用didSet, 计算配图的高度
        self.model = status
        
        // 2.强制更新界面
        self.layoutIfNeeded()
        
        // 3.返回底部视图最大的Y值
        return CGRectGetMaxY(bottomView.frame)
    }
}
