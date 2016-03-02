//
//  PopTitleController.swift
//  SinaWeiBo
//
//  Created by yangtao on 1/17/16.
//  Copyright © 2016 Rain YANG. All rights reserved.
//

import UIKit

class PopTitleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       print("PopTitleController")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
