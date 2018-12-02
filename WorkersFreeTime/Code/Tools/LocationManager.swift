//
//  LocationManager.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/12/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager:NSObject {
    static let instance = LocationManager()
    private let geocoder = CLGeocoder()
    
    private let manager = CLLocationManager()
    typealias locationCallBack = (_ curPlacemark:CLPlacemark?,_ error:Error?)->()
    
    var  callBack:locationCallBack?
    
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        manager.distanceFilter = 100
        
        //发送授权申请
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        
    }
    
    func startLocation(resultBack:@escaping locationCallBack) {
        
        self.callBack = resultBack
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            
        }
        
    }
}

extension LocationManager:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        let location = locations.first
        
        if let _ = location {
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
                if let callBack = self.callBack{
                    callBack(placemarks?.first, error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}

