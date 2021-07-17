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
    public var address = "" // 外传
    public var coordinate: CLLocationCoordinate2D? //1 地址取point
    public var distanceResult: AMapDistanceResult?
    
    public init(address: String) {
        self.address = address
    }
    
    public var defaultCenter: CLLocationCoordinate2D {
        return coordinate  ?? kCLLocationCoordinate2DInvalid
    }
    
    public var isOk: Bool {
        return CLLocationCoordinate2DIsValid(defaultCenter)
    }
    
    public var fromatDistance: String {
        guard let distance = distanceResult?.distance else {
            return "距离：--"
        }
        
        if distance < 1000 {
            return "距离：\(distance)米"
        }
        
        let r = (distance.double/1000.0).formatCustom("#0.##")
        return "距离：\(r)千米"
    }
    
    public var fromatDuration: String {
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
