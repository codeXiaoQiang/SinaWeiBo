//
//  ScanCodeController.swift
//  SinaWeiBo
//
//  Created by  Rain Yang on 1/20/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit
import AVFoundation
class ScanCodeController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    
    var timer:NSTimer?
    override func viewDidLoad() {
        super.viewDidLoad()

        setNav()
        setupViews()
        
        beginScan()
    }
    
    private func beginScan() {
       
        
        // 1.判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput)
        {
            return
        }
        // 2.判断是否能够将输出添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.将输入和输出都添加到会话中
        session.addInput(deviceInput)
        print(output.availableMetadataObjectTypes)
        session.addOutput(output)
        print(output.availableMetadataObjectTypes)
        
        // 4.设置输出能够解析的数据类型
        // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
        output.metadataObjectTypes =  output.availableMetadataObjectTypes
        print(output.availableMetadataObjectTypes)
        // 5.设置输出对象的代理, 只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        // 如果想实现只扫描一张图片, 那么系统自带的二维码扫描是不支持的
        // 只能设置让二维码只有出现在某一块区域才去扫描
        //        output.rectOfInterest = CGRectMake(0.0, 0.0, 1, 1)
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 添加绘制图层到预览图层上
        previewLayer.addSublayer(drawLayer)
        
        // 6.告诉session开始扫描
        session.startRunning()
        
        //扫描定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("scrollScanAction"), userInfo: nil, repeats: true)
    }
    
    private func setNav() {
        navigationItem.title = "扫一扫"
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.grayColor()
        
        view.addSubview(scanImageView)
        view.addSubview(tipTextLable)
        view.addSubview(myQRTextLable)
        view.addSubview(scrollLine)
    }
     //初始化扫码框
    var scanImageView:UIImageView = {
    
        let scanImageView = UIImageView()
        scanImageView.image = UIImage(named: "pick_bg")
        
        return scanImageView
    }()
    
    //扫描条
    var scrollLine:UIImageView = {
        
        let scrollLine = UIImageView()
        scrollLine.image = UIImage(named: "line")
        scrollLine.hidden = true
        
        return scrollLine
    }()

    
    //初始化提醒文字
    var tipTextLable:UILabel = {
        
        let tipTextLable = UILabel()
        tipTextLable.backgroundColor = UIColor.redColor()
        tipTextLable.text = "将二维码放入框内,即可自动扫描"
        tipTextLable.textColor = UIColor.whiteColor()
        tipTextLable.font = UIFont.systemFontOfSize(13.0)
        
        return tipTextLable
    }()
    
    //初始化生成二维码文字
    var myQRTextLable:UILabel = {
        
        let myQRTextLable = UILabel()
        myQRTextLable.backgroundColor = UIColor.redColor()
        myQRTextLable.text = "我的二维码"
        myQRTextLable.textColor = UIColor.whiteColor()
        myQRTextLable.font = UIFont.systemFontOfSize(13.0)
        return myQRTextLable
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scanImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view)
        }
        
        let width:CGFloat = (ScreenWidth - 190)/2
        tipTextLable.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(scanImageView).offset(20)
            make.width.equalTo(190)
            make.left.equalTo(self.view).offset(width)
            make.height.equalTo(20)
        }
        
        let myQRText_width:CGFloat = (ScreenWidth - 80)/2
        myQRTextLable.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(tipTextLable).offset(40)
            make.width.equalTo(80)
            make.left.equalTo(self.view).offset(myQRText_width)
            make.height.equalTo(20)
        }
        
        scrollLine.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(220)
            make.top.equalTo(self.scanImageView.snp_top)
            make.centerX.equalTo(scrollLine.superview!.snp_centerX)
            make.height.equalTo(5)
        }
    }
    
    
    // MARK: - 懒加载
    // 会话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    // 拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        // 获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            // 创建输入对象
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch
        {
            print(error)
            return nil
        }
    }()
    
    // 拿到输出对象
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    // 创建用于绘制边线的图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()

    
    // MARK: - Event Actions
    // 定时器控制扫描控件
    func scrollScanAction() {
        scrollLine.hidden = false
        scrollLine.snp_updateConstraints { (make) -> Void in
            // error,因为supdate只能更新原有约束的值,并不能加入新的约束
            // make.bottom.equalTo(self.qrcodeView.codeView.snp_bottom).offset(-10)
            make.top.equalTo(scanImageView.snp_top).offset(270)
        }
        UIView.animateWithDuration(1.9, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                self.scrollLine.snp_updateConstraints { (make) -> Void in
                    make.top.equalTo(self.scanImageView.snp_top).offset(5)
                }
        }
    }
    
    //MARK-AVCaptureMetadataOutputObjectsDelegate
    // 只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        // 0.清空图层
        clearConers()
        
        // 1.获取扫描到的数据
        // 注意: 要使用stringValue

        
        // 刷取出来的数据
        if metadataObjects.last?.stringValue != nil {
            print(metadataObjects.last?.stringValue)
            
            session.stopRunning()
            if ((metadataObjects.last?.stringValue.lowercaseString.hasPrefix("http")) != nil) {
                UIApplication.sharedApplication().openURL(NSURL(string: (metadataObjects.last?.stringValue)!)!)
                self.navigationController!.popViewControllerAnimated(true)
            }
        }

        
        // 2.获取扫描到的二维码的位置
        // 2.1转换坐标
        for object in metadataObjects
        {
            // 2.1.1判断当前获取到的数据, 是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject
            {
                // 2.1.2将坐标转换界面可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                // 2.1.3绘制图形
                drawCorners(codeObject)
            }
        }
    }
    
    /**
     绘制图形
     
     :param: codeObject 保存了坐标的对象
     */
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject)
    {
        if codeObject.corners.isEmpty
        {
            return
        }
        
        // 1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2.创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        // 2.1移动到第一个点
        // 从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        // 2.2移动到其它的点
        while index < codeObject.corners.count
        {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        // 2.3关闭路径
        path.closePath()
        
        // 2.4绘制路径
        layer.path = path.CGPath
        
        // 3.将绘制好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
    }
    /**
     清空边线
     */
    private func clearConers(){
        // 1.判断drawLayer上是否有其它图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        
        // 2.移除所有子图层
        for subLayer in drawLayer.sublayers!
        {
            subLayer.removeFromSuperlayer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



