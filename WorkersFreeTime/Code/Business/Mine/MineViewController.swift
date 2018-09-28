//
//  MineViewController.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {
    
    var mun:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.fp_prefersNavigationBarHidden = true
        
        if let p = self.params {
            mun = p["mun"] as? Int
            print(p)
            print(mun)
        }
    }

}
