//
//  DeerLocationManager.swift
//  DeerLbs
//
//  Created by 梁泽 on 2021/7/3.
//

import Foundation
import SwiftComponents

@_exported import AMapLocationKit
@_exported import MAMapKit
@_exported import AMapSearchKit

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
    
    public lazy var search = AMapSearchAPI().then {
        $0.delegate = self
    }
    
    public private(set) var reGeocode: AMapLocationReGeocode?
    public private(set) var location: CLLocation?
    
    public static var defaultKey: String {
        let info = JSON(Bundle.main.infoDictionary ?? [String: String]())
        let bid = info["CFBundleIdentifier"].stringValue
        let user = "com.yce.houseDeer"
        let doctor = "com.yce.nurse"
        switch bid {
        case user: return "a4951ca38eae763d9c76dace4139191d"//用户端
        case doctor: return "961c7f2a814abcd524fc5ef5d19f7105"//医生端
        case "com.yce.houseDeer02": return "466719370590bc9234d811cb188bba52"
        default: return ""
        }
    }
    
    public static func startConfig(key: String = DeerLocationManager.defaultKey) {
        //https://lbs.amap.com/api/ios-location-sdk/guide/create-project/foundation-sdk
        AMapServices.shared().apiKey = key
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
            
        })
        
        MAMapView.metalEnabled = true
        //先定位一次
//        DeerLocationManager.shared.requestLocation { _, _ in
//            
//        }
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
    public func requestLocation(completion: @escaping ((DeerLocationManager, AMapLocationReGeocode?, CLLocation?) -> Void)) {
        locationManager.requestLocation(withReGeocode: true) { [weak self] location, reGeocode, error in
            guard let self = self else { return }
            
            if let location = location {
                self.location = location
            }
            
            if let reGeocode = reGeocode {
                self.reGeocode = reGeocode
            }
            
            completion(self, reGeocode, location)
        }
    }
    
    
    
    public typealias GeoCodeSearchCallback = ([AMapGeocode]) -> Void
    private var geoCodeSearchCallback: GeoCodeSearchCallback?
    /// 地理编码（地址转坐标）
    public func geoCodeSearch(address: String, completion: @escaping GeoCodeSearchCallback) {
        let request = AMapGeocodeSearchRequest()
        request.address = address
        search.aMapGeocodeSearch(request)
        self.geoCodeSearchCallback = completion
    }
    
    public typealias DistanceSearchCallback = ([AMapDistanceResult]) -> Void
    private var distanceSearchCallback: DistanceSearchCallback?
    /// 距离测量
    public func distanceSearch(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping DistanceSearchCallback) {
        let request = AMapDistanceSearchRequest()
        request.origins = [AMapGeoPoint.location(withLatitude: CGFloat(origin.latitude), longitude: CGFloat(origin.longitude))]
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destination.latitude), longitude: CGFloat(destination.longitude))
        request.type = .walk
        search.aMapDistanceSearch(request)
        
        self.distanceSearchCallback = completion
    }
}

//MARK: - 定位代理
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


//MARK: - 搜索代理
extension DeerLocationManager: AMapSearchDelegate {
    // 地理编码（地址转坐标） https://lbs.amap.com/api/ios-sdk/guide/map-data/geo
    public func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes == nil {
            return
        }
        geoCodeSearchCallback?(response.geocodes)
    }
    
    // 逆地理编码（坐标转地址）

    //  距离测量
    public func onDistanceSearchDone(_ request: AMapDistanceSearchRequest!, response: AMapDistanceSearchResponse!) {
        if response.results == nil {
            return
        }
        distanceSearchCallback?(response.results)
    }
    
}


//MARK: - 定全权限
public extension DeerLocationManager {
    /// 检测定位是否能成功
    @discardableResult
    static func checkCanLocationSuccess(sourceVc: UIViewController?) -> Bool {
        if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "定位服务未开启", message: "请在系统设置中开启定位服务(设置>隐私>定位服务>开启)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
            sourceVc?.present(alert, animated: true, completion: nil)
            return false;
        } else if NetworkReachabilityManager.default!.isReachable == false {
            let alert = UIAlertController(title: "获取定位失败", message: "请检查网络或稍后重试", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
            sourceVc?.present(alert, animated: true, completion: nil)
            return false;
        }
        return true
    }
    
    
   
}
