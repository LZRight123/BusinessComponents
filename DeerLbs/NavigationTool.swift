//
//  NavigationTool.swift
//  JZT_SUPPLIER
//
//  Created by 梁泽 on 2018/10/23.
//  Copyright © 2018 com.FBBC.JoinTown. All rights reserved.
//

import Foundation
import MapKit
import SwiftComponents

public class NavigationTool: NSObject {

    @objc public static var hasBaiduApp: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "baidumap://")!)
    }
    @objc public static var hasGaoDeApp: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "iosamap://")!)
    }
    
    static var bdStr: String?
    static var gdStr: String?
    
    public static func navigationWith( srcName: String = "我的位置", destinationName: String, sourceVC: UIViewController) {
        
        if destinationName.count == 0 {
            sourceVC.showText("该用户未上传地址，无法使用导航。")
            return
        }
        
        if hasBaiduApp {
            let bdUrlStr = "baidumap://map/direction?origin=\(srcName)&destination=\(destinationName)&coord_type=bd09ll&mode=driving&src=com.yce.nurse".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            bdStr = bdUrlStr
        }
        if hasGaoDeApp {
            let gdUrlStr = "iosamap://path?sourceApplication=鹿管家医生端&sname=\(srcName)&dname=\(destinationName)&t=0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            gdStr = gdUrlStr
        }
        
        if (hasBaiduApp == true && hasGaoDeApp == true) {//弹框
           
            let alterVC = UIAlertController(title: "请选择导航方式", message: nil, preferredStyle: .actionSheet)
            alterVC.addAction(.init(title: "取消", style: .cancel, handler: nil))
            alterVC.addAction(.init(title: "高德地图", style: .default, handler: { _ in
                openGaodeApp()
            }))
            alterVC.addAction(.init(title: "百度地图", style: .default, handler: { _ in
                openBaiduApp()
            }))
            
            sourceVC.presentVC(alterVC, animated: true, completion: nil)
        } else if hasBaiduApp == true {
            openBaiduApp()
        } else if  hasGaoDeApp == true {
            openGaodeApp()
        } else {
            sourceVC.showText("您尚未安装导航软件，请先安装。")
        }
    }
    
    public static func openBaiduApp()  {
        UIApplication.shared.open(URL(string: bdStr ?? "baidumap://")!, options: [:], completionHandler: nil)
    }
    
    public static func openGaodeApp() {
        UIApplication.shared.open(URL(string: gdStr ?? "iosamap://")!, options: [:], completionHandler: nil)
//        UIApplication.shared.openURL(URL(string: gdStr ?? "iosamap://")!)
    }
}
