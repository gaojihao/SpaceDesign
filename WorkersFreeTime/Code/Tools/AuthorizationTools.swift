//
//  AuthorizationTools.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/12/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import Foundation
import AVFoundation

func startCamera(success:(() -> Void)?,failure:(() -> Void)?) {
    
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    if status == .denied || status == .restricted {
        
        if let f = failure {
            DispatchQueue.main.async {
                f()
            }
        }
    }else if status == .notDetermined{
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                if let s = success {
                    DispatchQueue.main.async {
                        s()
                    }
                }
            }else{
                if let f = failure {
                    DispatchQueue.main.async {
                        f()
                    }
                }
            }
        }
        
    }else{
        if let s = success {
            DispatchQueue.main.async {
                s()
            }
        }
    }
    
}

