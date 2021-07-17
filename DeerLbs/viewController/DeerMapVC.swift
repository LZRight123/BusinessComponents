//
//  DeerMapVC.swift
//  DeerLbs
//
//  Created by 梁泽 on 2021/7/4.
//

import UIKit
import SwiftComponents
@_exported import MAMapKit

public extension AMapGeoPoint {
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}

public extension DeerMapVC {
    /// 导航按钮 跳导航详情  需求： http://confluence.hbluguanjia.com/pages/viewpage.action?pageId=27951249
    static func testJump(forAddress address: String, soureVC: UIViewController,  coordinate: CLLocationCoordinate2D? = nil) {
        soureVC.showLoading()
    
        if address.isEmpty {
            soureVC.hiddeLoading()
            soureVC.showText("该用户地址信息有误，该功能不可用")
            return
        }
        // 同步请求 1，地理位置编码， 2，自己位置定位一次 3，距离计算
        var model = NavgatorDetailModel(address: address)
        model.coordinate = coordinate
        let group = DispatchGroup()
        
        // 1
        if coordinate == nil  {
            group.enter()
            DeerLocationManager.shared.geoCodeSearch(address: address, completion: {  list in
                model.coordinate = list.first?.location.coordinate
                group.leave()
            })
        }
       
        
        // 2
        group.enter()
        DeerLocationManager.shared.requestLocation { _, _, l in
            group.leave()
        }
       
        
        group.notify(queue: .main, execute: { [weak soureVC] in
            guard model.isOk, let location = DeerLocationManager.shared.location, let coor = model.coordinate else {
                soureVC?.hiddeLoading()
                soureVC?.showText("该用户地址信息有误，该功能不可用")
                return
            }
            
            DeerLocationManager.shared.distanceSearch(origin: location.coordinate, destination: coor) { [weak soureVC] list in
                model.distanceResult = list.first
                
                soureVC?.hiddeLoading()
                let nextVC = DeerMapVC(model: model)
                soureVC?.pushVC(nextVC)
            }
            
        })
    }
    

    
    
}

open class DeerMapVC: UIViewController {
    public lazy var mapView = MAMapView().then {
        $0.zoomLevel = 15
        // 定位小点
        let user = MAUserLocationRepresentation()
        user.showsAccuracyRing = false
        user.showsHeadingIndicator = false
        user.locationDotFillColor = .main
        $0.update(user)
        $0.showsUserLocation = false
        
        $0.delegate = self
    }
    let wrapBtn = WrapBtn().then {
        $0.btn.setTitleForAllStates("开始导航")
    }
    
    ///请用类方法跳转
    let model: NavgatorDetailModel
    init(model: NavgatorDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "导航详情"
        
        view.backgroundColor = .white
        mapView.frame = view.bounds
        view.add(mapView)
        
        view.add(wrapBtn).snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalTo(view.safeArea.bottom).offset(-45)
        })
        wrapBtn.btn.rx.tap
            .subscribe(onNext: { [unowned self] in
                NavigationTool.navigationWith(destinationName: self.model.address, sourceVC: self, lat: self.model.coordinate?.latitude, lon: self.model.coordinate?.longitude)
            })
            .disposed(by: disposeBag)
        
        let pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = model.defaultCenter
        mapView.addAnnotation(pointAnnotation)
        mapView.selectAnnotation(pointAnnotation, animated: true)
    }
    
    
}

//MARK: - 地图代理
extension DeerMapVC: MAMapViewDelegate {
    public func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        guard let annotation = annotation as? MAPointAnnotation else {
            return nil
        }
        
        let pointReuseIndetifier = "pointReuseIndetifier"
        var annotationView: MAPinAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MAPinAnnotationView
        
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
        }
        
        annotationView.canShowCallout = true
        annotationView.animatesDrop = false 
        annotationView.isDraggable = true
//        annotationView.rightCalloutAccessoryView = CallOutView()
        annotationView.pinColor = .red
//        annotationView.image = UIImage(named: "location268")
        
        
        var callView: CallOutView!
        if let c = annotationView.customCalloutView?.viewWithTag(101) as? CallOutView {
            callView = c
        } else {
            let custom = CallOutView()
            custom.tag = 101
            annotationView.customCalloutView = .init(customView: custom)
            
            custom.rightBtn.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    NavigationTool.navigationWith(destinationName: self.model.address, sourceVC: self, lat: self.model.coordinate?.latitude, lon: self.model.coordinate?.longitude)
                
                })
                .disposed(by: disposeBag)
            
            callView = custom
        }
        
        callView.addressLabel.text = model.address
        callView.distanceLabel.text = model.fromatDistance
        callView.durationLabel.text = model.fromatDuration
        
        annotationView.calloutOffset = .init(x: -(CallOutView.w * 0.5), y: -110)
        return annotationView!
        
    }
    
}
