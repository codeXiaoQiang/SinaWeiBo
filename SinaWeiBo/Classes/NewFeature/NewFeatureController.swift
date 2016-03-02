//
//  NewFeatureController.swift
//  SinaWeiBo
//
//  Created by yangtao on 1/24/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

private let Identifier = "featureCell"
class NewFeatureController: UIViewController {
    
    private let pageNumber = 4
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化loadCollectionView
        loadCollectionView()
    }
    
    private func loadCollectionView() {
    
        // 实例化CollectionView
        let colletionViewFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        let Layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: colletionViewFrame, collectionViewLayout: Layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 1.设置layout布局
        Layout.itemSize = UIScreen.mainScreen().bounds.size
        Layout.minimumInteritemSpacing = 0
        Layout.minimumLineSpacing = 0
        Layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.pagingEnabled = true
        
        //注册CollectionViewCell
        collectionView.registerClass(featureCell.self, forCellWithReuseIdentifier: Identifier)
        
        view.addSubview(collectionView)
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewFeatureController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageNumber
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Identifier, forIndexPath: indexPath) as!featureCell
        cell.imageIndex = indexPath.item
        
        //解决cell的循环使用
        if indexPath.item == 1 {
            cell.startButton.hidden = true
        }
        
        if indexPath.item == 3 {
            
            cell.startAnimation()
        }
        return cell
    }

    //cell展示完毕之后调用 页面一进来的时候不会调用
//    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//    
//        //拿到当前显示的cell
//        let path = collectionView.indexPathsForVisibleItems().first
//        if  path?.item == 0 || path?.item == 3{
//        
//                let cell = collectionView.cellForItemAtIndexPath(path!) as! featureCell
//                cell.startAnimation()
//        }
//    
//        print("pathpath = \(path)")
//    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }

}

class featureCell:UICollectionViewCell {

    private var imageIndex:Int? {
        didSet{
            featureImage.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化子控件
        setupChildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChildView() {

        contentView.addSubview(featureImage)
        contentView.addSubview(startButton)
        
    }
    
    private lazy var featureImage = UIImageView()
    private lazy var startButton:UIButton = {
    
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: "customBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func customBtnClick() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(switchkey, object: true)
        print(__FUNCTION__)
    }
    
    //布局子控件
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        featureImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        startButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self).offset(CGPointMake(0, 40))
        }
    }
    
   private func startAnimation() {
        
            startButton.hidden = false
            
            // 执行动画
            startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
            startButton.userInteractionEnabled = false
            
            // UIViewAnimationOptions(rawValue: 0) == OC knilOptions
            //usingSpringWithDamping 的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显,
            //initialSpringVelocity 则表示初始的速度，数值越大一开始移动越快
            UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                // 清空形变
                self.startButton.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    self.startButton.userInteractionEnabled = true
            })
    }
    
}
