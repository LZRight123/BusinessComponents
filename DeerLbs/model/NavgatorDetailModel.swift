//
//  NavDtailModel.swift
//  DeerLbs
//
//  Created by 梁泽 on 2021/7/4.
//

import Foundation
import CoreLocation
import SwiftComponents

struct NavgatorDetailModel {
    var address = "" // 外传
    var geocode: AMapGeocode? //1 地址取point
    var distanceResult: AMapDistanceResult?
    
    var defaultCenter: CLLocationCoordinate2D {
        return geocode?.location.coordinate  ?? kCLLocationCoordinate2DInvalid
    }
    
    var isOk: Bool {
        return CLLocationCoordinate2DIsValid(defaultCenter)
    }
    
    var fromatDistance: String {
        guard let distance = distanceResult?.distance else {
            return "距离：--"
        }
        
        if distance < 1000 {
            return "距离：\(distance)米"
        }
        
        let r = (distance.double/1000.0).formatCustom("#0.##")
        return "距离：\(r)千米"
    }
    
    var fromatDuration: String {
        guard let duration = distanceResult?.duration else {
            return "预计(步行)：--"
        }
        
        let cal = SecondCalculate(second: TimeInterval(duration))
        if cal.hour == 0 {
            return "预计(步行)：\(cal.minute)分钟"
        }
        return "预计(步行)：\(cal.hour)小时\(cal.minute)分钟"
    }
    
}
