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
    private var sysLocationManager = CLLocationManager()
    
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
        case "com.yce.nurse02": return "1950a6bd2ca74155ee9809a8bea944d0"
        default:
            assert(false, "请输入正常的key")
            return ""
        }
    }
    
    public static func startConfig(key: String = DeerLocationManager.defaultKey) {
        //https://lbs.amap.com/api/ios-location-sdk/guide/create-project/foundation-sdk
        AMapServices.shared().apiKey = key
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
            
        })
        
        MAMapView.metalEnabled = true
        //先定位一次
        DeerLocationManager.shared.requestLocation { _, r, _ in
            
        }
    }
    
    /// 开启持续定位
    public func startUpdatingLocation() {
        requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    ///  停止持续定位
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// 定一次位
    public func requestLocation(completion: @escaping ((DeerLocationManager, AMapLocationReGeocode?, CLLocation?) -> Void)) {
        requestWhenInUseAuthorization()
        locationManager.requestLocation(withReGeocode: true) { [weak self] location, reGeocode, error in
            guard let self = self else { return }
            
            if let location = location {
                self.location = location
//                let request = AMapReGeocodeSearchRequest()
//                request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
//                request.requireExtension = true
//                self.search.aMapReGoecodeSearch(request)
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
    
    
    func requestWhenInUseAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        
        case .notDetermined://用户没有选择是否要使用定位服务（弹框没选择，或者根本没有弹框）
            sysLocationManager.requestWhenInUseAuthorization()
            print("位置授权： notDetermined")
        case .restricted: //定位服务授权状态受限制，可能由于活动限制了定位服务，并且用户不能改变当前的权限，这个状态有可能不是用户拒绝的，但是也有可能是用户拒绝的
            sysLocationManager.requestWhenInUseAuthorization()
            print("位置授权： restricted")
        case .denied: ////用户在设置中关闭定位功能，或者用户明确的在弹框之后选择禁止定位
            sysLocationManager.requestWhenInUseAuthorization()
            print("位置授权： denied")
        case .authorizedAlways:
            print("位置授权： authorizedAlways")
        case .authorizedWhenInUse:
            print("位置授权： authorizedWhenInUse")
        @unknown default:
            break
        }
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
    public func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
     
        if let regeocode =  response.regeocode  {
            print("")
        }
        print("")
    }
    
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
