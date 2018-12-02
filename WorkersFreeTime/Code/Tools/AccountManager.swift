//
//  AccountManager.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/12/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import Foundation

class Account{
    var img:String?
    var jwt:String?
    var nickname:String?
    var bio: String?
    var phone:String?
    var renterUserId:String?
    var isLogin:Bool = false
}

class AccountManager {
    static let sharedInstance = AccountManager()
    
    var account = Account()
    
    init() {
        loadAccountInfoFromDisk()
    }
    
    var uid: String {
        return account.renterUserId ?? ""
    }
    
    
    func saveAccountInfoToDisk() {
        
        let ud = UserDefaults.standard
        
        ud.set(account.phone, forKey: "kUserMobile")
        ud.set(account.nickname, forKey: "kUserNickName")
        ud.set(account.bio, forKey: "kUserBio")
        ud.set(account.img, forKey: "kUserHeaderImage")
        ud.set(account.jwt, forKey: "kUserTWT")
        ud.set(account.renterUserId, forKey: "kUserUID")
        ud.set(account.isLogin, forKey: "kUserLogined")
        
        UserDefaults.standard.synchronize()
    }
    
    private func loadAccountInfoFromDisk(){
        
        let ud = UserDefaults.standard
        
        account.phone = ud.object(forKey: "kUserMobile") as? String
        account.nickname = ud.object(forKey: "kUserNickName") as? String
        account.bio = ud.object(forKey: "kUserBio") as? String ?? "Bio will appear here"
        account.img = ud.object(forKey: "kUserHeaderImage") as? String
        account.jwt = ud.object(forKey: "kUserTWT") as? String
        account.renterUserId = ud.object(forKey: "kUserUID") as? String
        account.isLogin = ud.bool(forKey: "kUserLogined")
        
    }
    
    func clearAccoutInfo() {
        account.phone = String()
        account.nickname = String()
        account.bio = String()
        account.img = String()
        account.renterUserId = String()
        account.isLogin = false
        
        saveAccountInfoToDisk()
    }
    
}

