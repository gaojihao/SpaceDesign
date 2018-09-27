//
//  MainTabBarController.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tabBarAppearance()
        buildMainTabBarChildViewController()
    }
    
    private func tabBarAppearance() {
        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().backgroundColor = UIColor.white
//        UITabBar.appearance().shadowImage = UIImage()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(0x999999),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.5)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(0x000000),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.5)], for: .selected)
    }
    
    private func buildMainTabBarChildViewController(){
        tabBarControllerAddChildViewController(childVC: HomeViewController(), title: "首页", imageName: "home", selectedImageName: "home_l")
        tabBarControllerAddChildViewController(childVC: HomeViewController(), title: "订单", imageName: "order", selectedImageName: "order_l")
        tabBarControllerAddChildViewController(childVC: HomeViewController(), title: "我的", imageName: "mine", selectedImageName: "mine_l")
    }
    
    private func tabBarControllerAddChildViewController(childVC: UIViewController,
                                                        title: String,
                                                        imageName: String,
                                                        selectedImageName: String){
        let vcItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        
        vcItem.selectedImage = vcItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        vcItem.image = vcItem.image?.withRenderingMode(.alwaysOriginal)
        
        childVC.tabBarItem = vcItem
        childVC.title = title
        childVC.edgesForExtendedLayout = .all
        
        let navigationVC = BaseNavigationController(rootViewController: childVC)
        
        addChild(navigationVC)
        
    }

}
