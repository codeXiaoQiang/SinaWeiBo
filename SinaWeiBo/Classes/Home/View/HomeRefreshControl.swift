 //
//  HomeRefreshControl.swift
//  SinaWeiBo
//
//  Created by yangtao on 2/23/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
class HomeRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        
        //添加子控件
        addSubview(refreshView)
        
        //布局子控件
        refreshView.snp_makeConstraints { (make) -> Void in
        make.center.equalTo(self.snp_center)
        make.height.equalTo(60)
        make.width.equalTo(170)
        }
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    /// 定义变量记录是否需要旋转监听
    private var rotationArrowFlag = false
    /// 定义变量记录当前是否正在执行圈圈动画
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y > 0 {
            
            return
        }
        
        //正在旋转刷新
        if refreshing && !loadingViewAnimFlag {
        
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startLoadingViewAnim()
            return
        }
        
        if frame.origin.y >= -50 && rotationArrowFlag
        {
       
            rotationArrowFlag = false
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
       
            rotationArrowFlag = true
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        // 关闭圈圈动画
        refreshView.stopLoadingViewAnim()
        
        // 复位圈圈动画标记
        loadingViewAnimFlag = false
    }
    
    //移除监听
    deinit{
    
            removeObserver(self, forKeyPath: "frame")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var refreshView:RefreshView = {
        
       let refreshView = RefreshView.loadrefreshView()
        return refreshView
    }()
}
 
class RefreshView:UIView {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    //执行旋转动画
    func startLoadingViewAnim() {
    
        tipView.hidden = true
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        // 该属性默认为YES, 代表动画只要执行完毕就移除
        anim.removedOnCompletion = false
        // 3.将动画添加到图层上
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    //执行箭头反转动画
    func rotaionArrowIcon(flag: Bool)
    {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    //关闭动画
    func stopLoadingViewAnim() {
        
        tipView.hidden = false
        loadingView.layer.removeAllAnimations()
    }

   class func loadrefreshView() -> RefreshView {
    
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! RefreshView
    }
}

