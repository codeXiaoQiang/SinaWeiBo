//
//  PhotoBrowserController.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/24/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SVProgressHUD
private let photoCellIdentifier = "photoCell"
class PhotoBrowserController: UIViewController {

    var currentIndex: Int?
    var pictureURLs: [NSURL]?
    
    init(index: Int, urls: [NSURL])
    {
        // Swift语法规定, 必须先初始化本类属性, 再初始化父类
        currentIndex = index
        pictureURLs = urls
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
       
        layoutChildUI()
    }
    
    private func setupUI(){
        
        view.backgroundColor = UIColor.blackColor()
        view.addSubview(photoBrowserView);
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //初始化CollectView
        setupCollectView()
    }
    
    private func setupCollectView() {
        
        photoBrowserView.dataSource = self;
        photoBrowserView.registerClass(PhotoBrowseCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
        pictureLayout.itemSize = UIScreen.mainScreen().bounds.size
        pictureLayout.minimumInteritemSpacing = 0
        pictureLayout.minimumLineSpacing = 0
        pictureLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        photoBrowserView.showsHorizontalScrollIndicator = false
        photoBrowserView.pagingEnabled = true
        photoBrowserView.bounces =  false
    
    }
    
    private func layoutChildUI(){
    
        closeBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(10)
            make.bottom.equalTo(view.snp_bottom).offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        saveBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view.snp_right).offset(-10)
            make.bottom.equalTo(view.snp_bottom).offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        photoBrowserView.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(self.view.snp_center)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight)
        }
    }
    
    private lazy var closeBtn:UIButton = {
    
        let closeBtn = UIButton()
        closeBtn.backgroundColor = UIColor.grayColor()
        closeBtn.setTitle("关闭", forState: UIControlState.Normal)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.addTarget(self, action: "dismissController", forControlEvents: UIControlEvents.TouchUpInside)
        return closeBtn
    }()
    
    private lazy var saveBtn:UIButton = {
        
        let saveBtn = UIButton()
        saveBtn.backgroundColor = UIColor.grayColor()
        saveBtn.setTitle("保存", forState: UIControlState.Normal)
        saveBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveBtn.addTarget(self, action: "didSave", forControlEvents: UIControlEvents.TouchUpInside)
        return saveBtn
    }()
    
    private lazy var pictureLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var photoBrowserView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.pictureLayout)
    
    func dismissController() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSave() {
        
        let index = photoBrowserView.indexPathsForVisibleItems().last
        let cell = photoBrowserView.cellForItemAtIndexPath(index!) as! PhotoBrowseCell
    
        let image = cell.photoImageView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        

        print(__FUNCTION__)
    }
    
    func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject){
        if error != nil
        {
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
        }else
        {
            SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
        }
    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhotoBrowserController: UICollectionViewDataSource, PhotoBrowserCellDelegate {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! PhotoBrowseCell
        //cell.backgroundColor = UIColor.randomColor()
        cell.pictureImageURL = pictureURLs![indexPath.item]
        cell.photoBrowserCellDelegate = self
        //cell.index = currentIndex
        return cell
    }
    
    func photoBrowserCellDidClose(cell: PhotoBrowseCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
