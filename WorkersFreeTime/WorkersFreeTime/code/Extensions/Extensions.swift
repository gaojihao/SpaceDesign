//
//  Extensions.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorWithHexString(_ hex:String, alpha: Double=1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.init(red: r / 255,
                            green: g / 255,
                            blue: b / 255,
                            alpha: 1.0)
    }
    
    static func colorFromHex(_ Hex: UInt32) -> UIColor {
        return UIColor.init(red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((Hex & 0xFF00) >> 8) / 255.0,
                            blue: CGFloat((Hex & 0xFF)) / 255.0,
                            alpha: 1.0)
    }
}
