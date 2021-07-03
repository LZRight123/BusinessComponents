//
//  DeerLocationManager.swift
//  DeerLbs
//
//  Created by 梁泽 on 2021/7/3.
//

import Foundation
@_exported import AMapLocationKit
public class DeerLocationManager: NSObject  {
    public static let shared = DeerLocationManager()
    
    public lazy var locationManager = AMapLocationManager().then {
        $0.distanceFilter = 200
        $0.locatingWithReGeocode = true
        $0.delegate = self
        
        // 单次定位配置
        $0.desiredAccuracy = kCLLocationAccuracyHundredMeters
        $0.locationTimeout = 2
        $0.reGeocodeTimeout = 2
    }
    
    public private(set) var reGeocode: AMapLocationReGeocode?
    public private(set) var location: CLLocation?
    
    public static func startConfig(key: String = "466719370590bc9234d811cb188bba52") {
        //https://lbs.amap.com/api/ios-location-sdk/guide/create-project/foundation-sdk
        AMapServices.shared().apiKey = key
    }
    
    /// 开启持续定位
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    ///  停止持续定位
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// 定一次位
    public func requestLocation(completion: @escaping ((DeerLocationManager, AMapLocationReGeocode?) -> Void)) {
        locationManager.requestLocation(withReGeocode: true) { [weak self] location, reGeocode, error in
            guard let self = self else { return }
            
            if let location = location {
                self.location = location
            }
            
            if let reGeocode = reGeocode {
                self.reGeocode = reGeocode
            }
            
            completion(self, reGeocode)
        }
    }
    
}


extension DeerLocationManager: AMapLocationManagerDelegate {
    
    public func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        if location != nil {
            self.location = location
        }
        if reGeocode != nil {
            self.reGeocode = reGeocode
        }
    }
}
