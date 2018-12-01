//
//  UrlSchemeManager.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/28.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

let HPScheme = UrlSchemeManager.shared


class UrlSchemeManager {
    static let shared = UrlSchemeManager()
    
    func open(_ viewControllerName:String!,navigator:UINavigationController!, params:[String : Any]?,method:UIViewControllerOpenMethod) {
        
        let viewController = getViewController(viewControllerName: viewControllerName, params: params)
        
        if let vc = viewController {
            vc.openType = method
            switch method{
            case .push:
                navigator.pushViewController(vc, animated: true)
            case .present:
                let presentNav = UINavigationController(rootViewController: vc)
                navigator.topViewController?.present(presentNav, animated: true, completion: nil)
            }
        }else{
            print("未能生成VC，无法跳转！")
        }
    }
    
    func push(_ viewControllerName:String!,navigator:UINavigationController!, params:[String : Any]?) {
        open(viewControllerName, navigator: navigator, params: params, method: .push)
    }
    
    func present(_ viewControllerName:String!,navigator:UINavigationController!, params:[String : Any]?) {
        open(viewControllerName, navigator: navigator, params: params, method: .present)
    }
    
    private func getViewController(viewControllerName:String, params:[String : Any]?) -> UIViewController?{
        let classType = NSClassFromString("WorkersFreeTime."+viewControllerName) as? UIViewController.Type
        
        let viewController:UIViewController! = classType!.init()
        
        if params == nil{
            return viewController
        }else{
            viewController.params = params
            return viewController
        }
        
    }
}
