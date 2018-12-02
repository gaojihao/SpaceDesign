//
//  LoadingPlugin.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/12/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit
import Moya
import Result
import NVActivityIndicatorView

final class LoadingPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        
        let activityData = ActivityData(size: CGSize(width: 40, height: 40),
                                        message: "Loading...",
                                        messageFont: UIFont.systemFont(ofSize: 15),
                                        type: .ballSpinFadeLoader,
                                        color: UIColor.black.withAlphaComponent(0.5),
                                        padding: nil,
                                        displayTimeThreshold: nil,
                                        minimumDisplayTime: nil,
                                        backgroundColor: UIColor.clear,
                                        textColor: UIColor.black)
        
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
    }

}
