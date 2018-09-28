//
//  BaseViewController.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        if let _ = self.openType {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn)
        }
    }
    
    @objc func backAction(){
        switch self.openType! {
        case .push:
            self.navigationController?.popViewController(animated: true)
            break
        case .present:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:Lazy Load
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "v2_goback"), for: .normal)
        backBtn.titleLabel?.isHidden = true
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = .left
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let btnW: CGFloat = UIScreen.main.bounds.width > 375.0 ? 50 : 44
        backBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 40)
        
        return backBtn
    }()

}
