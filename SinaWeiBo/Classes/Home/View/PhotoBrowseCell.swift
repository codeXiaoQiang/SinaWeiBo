//
//  PhotoBrowseCell.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/25/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate : NSObjectProtocol
{
    func photoBrowserCellDidClose(cell: PhotoBrowseCell)
}

class PhotoBrowseCell: UICollectionViewCell {
  
//    var index:Int? {
//        
//        didSet{
//                self.scrollview.contentOffset.x = CGFloat(index!) * ScreenWidth
//            }
//        
//
//    }
    
    var pictureImageURL:NSURL? {
    
        didSet{
            // 2.显示菊花
            activity.startAnimating()
            // 1.重置属性
            reset()
            
                photoImageView.sd_setImageWithURL(pictureImageURL) { (image, _, _, _) -> Void in
                    // 4.隐藏菊花
                    self.activity.stopAnimating()
                    self.setImageViewPostion()
            }
        }
    }
    
    /**
     重置scrollview和imageview的属性
     */
    private func reset()
    {
        // 重置scrollview
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
        
        // 重置imageview
        photoImageView.transform = CGAffineTransformIdentity
    }
    
    /**
     调整图片显示的位置
     */
    private func setImageViewPostion()
    {
        // 1.拿到按照宽高比计算之后的图片大小
        let size = self.displaySize(photoImageView.image!)
        // 2.判断图片的高度, 是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.height
        {
            // 2.2小于 短图 --> 设置边距, 让图片居中显示
            photoImageView.frame = CGRect(origin: CGPointZero, size: size)
            // 处理居中显示
            let y = (UIScreen.mainScreen().bounds.height - size.height) * 0.5
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
            
            
        }else
        {
            // 2.1大于 长图 --> y = 0, 设置scrollview的滚动范围为图片的大小
            photoImageView.frame = CGRect(origin: CGPointZero, size: size)
            scrollview.contentSize = size
        }
    }
    /**
     按照图片的宽高比计算图片显示的大小
     */
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
    
        contentView.addSubview(scrollview)
        scrollview.addSubview(photoImageView)
        contentView.addSubview(activity)
        scrollview.frame = UIScreen.mainScreen().bounds
        activity.center = contentView.center
        
        // 3.处理缩放
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        
        // 4.监听图片的点击
        let tap = UITapGestureRecognizer(target: self, action: "close")
        photoImageView.addGestureRecognizer(tap)
        photoImageView.userInteractionEnabled = true
        

    }
    
   weak var photoBrowserCellDelegate:PhotoBrowserCellDelegate?
    
    private var scrollview:UIScrollView = UIScrollView()
    private lazy var activity: UIActivityIndicatorView =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
     var photoImageView:UIImageView = {
    
        let  photoImageView = UIImageView()
        return photoImageView
    }()
    
    /**
     关闭浏览器
     */
    func close()
    {
        print("close")
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }
}

extension PhotoBrowseCell: UIScrollViewDelegate
{
    // 告诉系统需要缩放哪个控件
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return photoImageView
    }
    
    // 重新调整配图的位置
    // view: 被缩放的视图
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        
        // 注意: 缩放的本质是修改transfrom, 而修改transfrom不会影响到bounds, 只有frame会受到影响
        //        print(view?.bounds)
        //        print(view?.frame)
        
        var offsetX = (UIScreen.mainScreen().bounds.width - view!.frame.width) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - view!.frame.height) * 0.5
        //        print("offsetX = \(offsetX), offsetY = \(offsetY)")
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}

