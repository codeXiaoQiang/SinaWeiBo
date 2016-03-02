//
//  EmoticonViewController.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/28/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
private let XMGEmoticonCellReuseIdentifier = "XMGEmoticonCellReuseIdentifier"
class EmoticonViewController: UIViewController {

    //获取表情
    private lazy var packages: [EmoticonPackage] = EmoticonPackage.loadPackages()
    
    /// 定义一个闭包属性, 用于传递选中的表情模型
    var emoticonDidSelectedCallBack: (emoticon: Emoticon)->()
    
    init(callBack: (emoticon: Emoticon)->())
    {
        self.emoticonDidSelectedCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupCollection()
    }
    
    private func setupUI() {
        
        view.addSubview(toolBar)
        view.addSubview(emoticonView)
        
//        // 2.布局子控件
//        emoticonView.translatesAutoresizingMaskIntoConstraints = false
//        toolBar.translatesAutoresizingMaskIntoConstraints = false
//        
//         //提示: 如果想自己封装一个框架, 最好不要依赖其它框架
//        var cons = [NSLayoutConstraint]()
//        let dict = ["collectionVeiw":    emoticonView, "toolbar": toolBar]
//        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionVeiw]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
//        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
//        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionVeiw]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
//        
//        view.addConstraints(cons)
        
        toolBar.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(44)
            make.left.equalTo(view.snp_left).offset(0)
            make.bottom.equalTo(view.snp_bottom).offset(0)
        }

        emoticonView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(172)//键盘216
            make.left.equalTo(view.snp_left).offset(0)
            make.bottom.equalTo(toolBar.snp_top).offset(0)
        }
    }
    
    private func setupCollection() {
        
        // 注册cell
        emoticonView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: XMGEmoticonCellReuseIdentifier)
        emoticonView.dataSource = self
             emoticonView.delegate = self
        
        // 1.设置cell相关属性
        let width = ScreenWidth / 7
        layoutView.itemSize = CGSize(width: width, height: width)
        layoutView.minimumInteritemSpacing = 0
        layoutView.minimumLineSpacing = 0
        layoutView.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 2.设置collectionview相关属性
        emoticonView.pagingEnabled = true
        emoticonView.bounces = false
        emoticonView.showsHorizontalScrollIndicator = false
        
        // 注意:最好不要乘以0.5, 因为CGFloat不准确, 所以如果乘以0.5在iPhone4/4身上会有问题
        //let y = (216 - 3 * width) * 0.45
        emoticonView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)//emoticonView.bounds.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    private lazy var layoutView = UICollectionViewFlowLayout()
    private lazy var emoticonView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layoutView)
    
    private lazy var toolBar:UIToolbar = {
        
        var toolBar = UIToolbar()
        toolBar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
    
        var index = 0
        for title in ["最近", "默认", "Emoji", "浪小花"] {
          let item =  UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: "didCliclEmoticon:")
            item.tag = index++
            let FlexibleSpaceitem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            items.append(item)
            items.append(FlexibleSpaceitem)
       
        }
        
        items.removeLast()
        toolBar.items = items
        return toolBar
    }()
    
    func didCliclEmoticon(item:UIBarButtonItem) {
    
        emoticonView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
}


extension EmoticonViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = emoticonView.dequeueReusableCellWithReuseIdentifier(XMGEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! EmoticonCell
        
       // cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        
        // 1.取出对应的组
        let package = packages[indexPath.section]
        // 2.取出对应组对应行的模型
        let emoticon = package.emoticons![indexPath.item]
        // 3.赋值给cell
        cell.emoticon = emoticon

        
        return cell
    }
    
    // 选中某一个cell时调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 1.处理最近表情, 将当前使用的表情添加到最近表情的数组中
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emoticon.times++
        packages[0].appendEmoticons(emoticon)
        
        // 2.回调通知使用者当前点击了那个表情
        emoticonDidSelectedCallBack(emoticon: emoticon)
    }

}

class EmoticonCell: UICollectionViewCell {
    
    var emoticon: Emoticon?
        {
        didSet{
            // 1.判断是否是图片表情
            if emoticon!.chs != nil
            {
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), forState: UIControlState.Normal)
            }else
            {
                // 防止重用
                iconButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 2.设置emoji表情
            // 注意: 加上??可以防止重用
            iconButton.setTitle(emoticon!.emojiStr ?? "", forState: UIControlState.Normal)
            
            // 3.判断是否是删除按钮
            if emoticon!.isRemoveButton
            {
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }

        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    /**
     初始化UI
     */
    private func setupUI()
    {
        contentView.addSubview(iconButton)
        print(contentView.bounds)
        iconButton.backgroundColor = UIColor.whiteColor()
        //        iconButton.frame = contentView.bounds
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
        iconButton.userInteractionEnabled = false
        
    }
    
    // MARK: - 懒加载
    private lazy var iconButton: UIButton = UIButton()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


