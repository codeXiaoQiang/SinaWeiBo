//
//  HomeStatusPictureView.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/23/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

let showPictureController = "showPictureController"
/// 当前选中图片的索引对应的key
let XMGStatusPictureViewIndexKey = "XMGStatusPictureViewIndexKey"
/// 需要展示的所有图片对应的key
let XMGStatusPictureViewURLsKey = "XMGStatusPictureViewURLsKey"

class HomeStatusPictureView: UICollectionView {

    var model:StatusModel? {
        didSet {

            reloadData()
        }
    }
    
    
    private var pictureLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    init() {
        super.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight), collectionViewLayout: self.pictureLayout)
        
        //初始化ui
        setupcollectionView()
        
    }
    
    private func setupcollectionView() {
        // 1.注册cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: pictureViewCellIdentifier)
        
        // 2.设置数据源
        dataSource = self
        delegate = self
        
        // 2.设置cell之间的间隙
        self.pictureLayout.minimumInteritemSpacing = 5
        self.pictureLayout.minimumLineSpacing = 5
        backgroundColor = UIColor.whiteColor()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     计算配图的尺寸
     */
    func calculateImageSize() -> CGSize
    {
        // 1.取出配图个数
        let count = model?.storePic_URL?.count
        // 2.如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSizeZero
        }
        // 3.如果只有一张配图, 返回图片的实际大小
        if count == 1
        {
            // 3.1取出缓存的图片
            let key = model?.storePic_URL!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            
            if image == nil {
                return CGSizeZero
            }else {
                
                pictureLayout.itemSize = image.size
                return image.size
            }
        }
        
        // 4.如果有4张配图, 计算田字格的大小
        let width = 95
        let margin = 5
        pictureLayout.itemSize = CGSize(width: width, height: width)
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        /*
        2/3
        5/6
        7/8/9
        */
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        //               (8 - 1) / 3 + 1
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
        
    }

    
    private  class PictureViewCell: UICollectionViewCell {
        
        // 定义属性接收外界传入的数据
        var imageURL: NSURL?
            {
            didSet{
                iconImageView.sd_setImageWithURL(imageURL!)
                
                
                // 2.判断是否需要显示gif图标 // GIF
                if (imageURL!.absoluteString as NSString).pathExtension.lowercaseString == "gif"
                {
                    gifImageView.hidden = false
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            // 初始化UI
            setupUI()
        }
        
        
        private func setupUI()
        {
            // 1.添加子控件
            contentView.addSubview(iconImageView)
            
            iconImageView.addSubview(gifImageView)
            
            // 2.布局子控件
            gifImageView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconImageView, size: nil)
            
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // 2.布局子控件
            iconImageView.snp_makeConstraints { (make) -> Void in
                make.width.equalTo(contentView.snp_width)
                make.height.equalTo(contentView.snp_height)
                make.center.equalTo(contentView.snp_center)
            }
        }
        
        // MARK: - 懒加载
        
        private lazy var gifImageView: UIImageView = {
            let iv = UIImageView(image: UIImage(named: "avatar_vgirl"))
            iv.hidden = true
            return iv
        }()
        private lazy var iconImageView:UIImageView = {
            
            let iconImageView = UIImageView()
            return iconImageView
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    
}

extension HomeStatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.storePic_URL?.count ?? 0//??前面是nil返回后面的值
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureViewCellIdentifier, forIndexPath: indexPath) as! PictureViewCell
        
        // 2.设置数据
        cell.imageURL = model?.storePic_URL?[indexPath.item]
        
        // 3.返回cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return pictureLayout.itemSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let info = [XMGStatusPictureViewIndexKey : indexPath, XMGStatusPictureViewURLsKey : model!.storedLargePicURLS!]
        NSNotificationCenter.defaultCenter().postNotificationName(showPictureController, object: self, userInfo: info)

    }
}
