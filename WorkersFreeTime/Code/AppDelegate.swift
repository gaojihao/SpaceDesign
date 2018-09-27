//
//  AppDelegate.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FullscreenPopGesture.configure()
        setMainWindow()
        return true
    }
    
    func setMainWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()
    }


}

