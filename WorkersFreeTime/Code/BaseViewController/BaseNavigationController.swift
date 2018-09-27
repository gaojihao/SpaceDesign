//
//  BaseNavigationController.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
    }
    
    private func configNavigationBar(){
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:UIColor.colorFromHex(0x333333),.font:UIFont.boldSystemFont(ofSize: 17)]
        
    }

}
