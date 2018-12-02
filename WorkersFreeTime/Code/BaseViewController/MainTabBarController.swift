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
        self.tabBar.backgroundColor = UIColor.white
        tabBarAppearance()
        buildMainTabBarChildViewController()
    }
    
    private func tabBarAppearance() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().clipsToBounds = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(0x8a8a8a),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.5)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(0x16a515),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.5)], for: .selected)
    }
    
    private func buildMainTabBarChildViewController(){
        tabBarControllerAddChildViewController(childVC: HomeViewController(), title: "首页", imageName: "tab_home", selectedImageName: "tab_home_active")
        tabBarControllerAddChildViewController(childVC: DesignViewController(), title: "设计", imageName: "tab_create", selectedImageName: "tab_create_active")
        tabBarControllerAddChildViewController(childVC: MineViewController(), title: "我的", imageName: "tab_me", selectedImageName: "tab_me_active")
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
