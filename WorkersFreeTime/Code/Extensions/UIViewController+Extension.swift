//
//  UIViewController+Extension.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/28.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

enum UIViewControllerOpenMethod:Int {
    case push
    case present
}

extension UIViewController {
    private struct AssociatedKeys {
        static var openType:UIViewControllerOpenMethod?
        static var KEY_ViewController_Paramter = UnsafeRawPointer(bitPattern: "KEY_ViewController_Paramter".hashValue)
        
    }
    
    var openType:UIViewControllerOpenMethod?{
        
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.openType) as? UIViewControllerOpenMethod
        }
        
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.openType, newValue as UIViewControllerOpenMethod?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var params: [String:Codable]? {
        get {
            if let p = objc_getAssociatedObject(self, &AssociatedKeys.KEY_ViewController_Paramter) {
                return (p as! [String:Codable])
            }
            return [:]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.KEY_ViewController_Paramter, newValue as [String:Codable]?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
