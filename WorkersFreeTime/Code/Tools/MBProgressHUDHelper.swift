//
//  MBProgressHUDHelper.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/12/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import Foundation
import MBProgressHUD

class MBProgressHUDHelper {
    static func showWarning(text: String) {
        self.showWarning(text: text, imageStr: nil, delay: 2.0)
    }
    
    static func showWarning(text: String?, imageStr: String?, delay: TimeInterval) {
        if let textString = text {
            if textString.count > 0 {
                let window: UIWindow = UIApplication.shared.keyWindow!
                let hud = MBProgressHUD.showAdded(to: window, animated: true)
                
                if let img = imageStr {
                    let customView = self.getCustomView(text: text, imgString: img, superView: hud)
                    hud.minSize = CGSize(width: customView.frame.size.width + 20, height: customView.frame.size.height + 24);
                    hud.mode = MBProgressHUDMode.customView;
                    hud.customView = customView;
                } else {
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = text;
                    hud.label.numberOfLines = 0;
                }
                hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor;
                hud.backgroundView.color = UIColor.clear
                hud.hide(animated: true, afterDelay: delay)
            }
            
        }
    }
    
    static func getCustomView(text: String?, imgString: String?, superView: UIView) -> UIView{
        let customView = UIView.init()
        let iconImg = UIImage(named: imgString ?? "")
        
        let label = UILabel.init()
        label.text = text ?? ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        let contentSize: CGSize = NSString(string: label.text ?? "").boundingRect(with: CGSize.init(width: 200.0, height: Double(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: label.font], context: nil).size
        label.frame = CGRect(x: 0, y: iconImg?.size.height ?? 0.0 + 5.0, width: contentSize.width, height: contentSize.height)
        customView.addSubview(label)
        
        var width: CGFloat = contentSize.width
        if let image = iconImg {
            if width < image.size.width  {
                width = image.size.width + 4;
            }
            
            let iconImgView = UIImageView.init(frame: CGRect(x: (width-image.size.width)/2.0, y: 0, width: image.size.width, height: image.size.height))
            iconImgView.image = iconImg
            customView.addSubview(iconImgView)
        }
        customView.bounds = CGRect(x: width/2.0, y: label.frame.origin.y/2.0, width: width, height: label.frame.origin.y)
        customView.backgroundColor = UIColor.clear
        return customView
    }
}

