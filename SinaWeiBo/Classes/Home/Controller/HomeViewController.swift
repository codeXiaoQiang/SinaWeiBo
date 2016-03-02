//
//  HomeViewController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/12/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {
    
    //var rowHeight:CGFloat?
    
    //保存模型数组
    var homeStatusModel:[StatusModel]? {
        didSet {
            
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if !isShowLogin {//设置登陆界面
    
             baseLoginView?.setUpInfoLoginView(true, imageName: "visitordiscover_feed_image_house", text: "后可以看到最新的动态登录之后看到最新的动态登录之后后后可以看到最后")
            return
        }
        
        setupNav()
        
        tableView.registerClass(HomeStatusForwardCell.classForCoder(), forCellReuseIdentifier: StatusCellIdentifier.statusCell.rawValue)
        tableView.registerClass(HomeStatusForwardCell.classForCoder(), forCellReuseIdentifier: StatusCellIdentifier.forwardCell.rawValue)
        
        //监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPicture:", name: showPictureController, object: nil)
        
        //添加下啦刷新控件
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: "loadHomeData", forControlEvents: UIControlEvents.ValueChanged)
        
        //添加刷新提醒
        navigationController?.navigationBar.insertSubview(tipsView, atIndex: 0)
   
        //获取模型数据
        loadHomeData()
    }
    
    func showPicture(notifiction:NSNotification) {
        print("notifiction = \(notifiction.userInfo)")
        
        guard let indexPath = notifiction.userInfo![XMGStatusPictureViewIndexKey] as? NSIndexPath else
        {
            //条件不成力执行代码
            return
        }
        
        guard let urls = notifiction.userInfo![XMGStatusPictureViewURLsKey] as? [NSURL] else
        {
            return
        }

        let vc = PhotoBrowserController(index: indexPath.item, urls: urls);
        presentViewController(vc, animated: true, completion: nil)
    }
    
    private lazy var tipsView:UILabel = {
        
        let tipsView = UILabel()
        tipsView.textAlignment = NSTextAlignment.Center
        tipsView.backgroundColor = UIColor.orangeColor()
        tipsView.frame = CGRectMake(0, -64, ScreenWidth, 44)
        
        return tipsView
    }()
    
    /// 定义变量记录当前是上拉还是下拉
    var pullupRefreshFlag = false

    @objc func loadHomeData() {
        
        var since_id = homeStatusModel?.first?.id ?? 0
        
        var max_id = 0
        // 2.判断是否是上拉
        if pullupRefreshFlag
        {
            since_id = 0
            max_id = homeStatusModel?.last?.id ?? 0
        }

        StatusModel.loadStatus(since_id, max_id: max_id) { (models, error) -> () in
            
            self.refreshControl?.endRefreshing()
            if error != nil
            {
                return
            }
            if since_id > 0 {
        
                self.homeStatusModel = models! + self.homeStatusModel!
          
                //执行提醒动画
                self.tipsAnimation((models?.count)!)
            }else if max_id > 0
            {
                // 如果是上拉加载更多, 就将获取到的数据, 拼接在原有数据的后面
                  self.homeStatusModel =   self.homeStatusModel! + models!
            }else {
                
                self.homeStatusModel = models
            }
        }
    }
    
    private func tipsAnimation(count:Int) {
        
        self.tipsView.text = (count==0) ? "没有刷新到数据":"刷新到\(count)数据"
        
        let rect = self.tipsView.frame
        UIView.animateWithDuration(2, animations: { () -> Void in
            
            self.tipsView.frame = CGRectMake(0, 44, ScreenWidth, 44)
            }) { (_) -> Void in
             
                UIView.animateWithDuration(2, animations: { () -> Void in
                    self.tipsView.frame = rect
                })
        }
    }

    private func setupNav() {
        
        let titleButton = TitleButton()
        titleButton.sizeToFit()
        let titleName = AccountTools.getAccount()?.screen_name
        titleButton.setTitle(titleName, forState: UIControlState.Normal)
        navigationItem.titleView = titleButton
        titleButton.addTarget(self, action: "clickTtitle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftItem:UIBarButtonItem = UIBarButtonItem.itemWithImage("navigationbar_friendattention", highlightedImageNamed:  "navigationbar_friendattention_highlighted", target: self, action: "UserClick")
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem:UIBarButtonItem = UIBarButtonItem.itemWithImage("navigationbar_pop", highlightedImageNamed: "navigationbar_pop_highlighted", target: self, action: "QRCodeClick")
        navigationItem.rightBarButtonItem = rightItem
    }
    
      func UserClick(){
    
    }
    
     func QRCodeClick(){
        
//        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
//        let vc =  sb.instantiateInitialViewController()
//        presentViewController(vc!, animated: true, completion: nil)
        
        let scanVc = ScanCodeController()
        navigationController?.pushViewController(scanVc, animated: true)
    }
        
    func clickTtitle(btn:UIButton) {
      btn.selected = !btn.selected
        
        let sb = UIStoryboard(name: "TitleController", bundle: nil)
        let popVc = sb.instantiateInitialViewController()!
        
        popVc.modalPresentationStyle = .Custom
        popVc.transitioningDelegate = self
        presentViewController(popVc, animated: true) { () -> Void in
            
        }
    }
    
    /// 微博行高的缓存, 利用字典作为容器. key就是微博的id, 值就是对应微博的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }

    // 移除通知
    deinit {

      NSNotificationCenter.defaultCenter().removeObserver(self, name: showPictureController, object: nil)
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return MyPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        let animation = MyAnimatedTransitioning()
        animation.isPresented = true
        return animation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        let animation = MyAnimatedTransitioning()
        animation.isPresented = false
        
        return animation
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homeStatusModel?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 初始化cell
         let model = homeStatusModel![indexPath.row]
        //let cell = HomeStatusCell.cellWithTableView(tableView, indexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellID(model), forIndexPath: indexPath)  as? HomeStatusCell
        
        //赋值模型
        cell!.model = model
        
        // 4.判断是否滚动到了最后一个cell
        let count = homeStatusModel!.count ?? 0
        if indexPath.row == (count - 1)
        {
            pullupRefreshFlag = true
            //            print("上拉加载更多")
            loadHomeData()
        }

        
        //返回cell
       return cell!

       }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1.取出对应行的模型
        let status = homeStatusModel![indexPath.row]
        
        // 2.判断缓存中有没有
        if let height = rowCache[status.id]
        {
            return height
        }
        
        // 3.拿到cell
       let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellID(status)) as! HomeStatusCell

        // 4.拿到对应行的行高
        let rowHeight = cell.rowHeight(status)
        
        // 5.缓存行高
        rowCache[status.id] = rowHeight
        
        // 6.返回行高
        return rowHeight
    }
    
}
