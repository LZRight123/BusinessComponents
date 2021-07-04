//
//  CallOutView.swift
//  DeerLbs
//
//  Created by 梁泽 on 2021/7/4.
//

import UIKit
import SwiftComponents
class CallOutView: LZControl {
    static let w: CGFloat = 280
    let addressLabel = UILabel(font: .font16, textColor: .hex333333, text: "", numberOfLines: 1)
    let distanceLabel = UILabel(font: .font16, textColor: .hex333333, text: "", numberOfLines: 1)
    let durationLabel = UILabel(font: .font16, textColor: .hex333333, text: "", numberOfLines: 1)
    let rightBtn = LZItemStackView(image: UIImage(named: "daohao268"), text: "导航").then {
        $0.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        $0.titleLabel.textColor = .main
        $0.spacing = 6
    }
    
    
    lazy var vStack = UIStackView(arrangedSubviews: [addressLabel, distanceLabel, durationLabel], spacing: 6, alignment: .fill, distribution: .fill, axis: .vertical)
    
    
    override func setupUI() {
        backgroundColor = .clear
        snp.makeConstraints({
            $0.width.equalTo(CallOutView.w)
        })

        rightBtn.isHidden = true
//        add(rightBtn).snp.makeConstraints({
//            $0.right.equalToSuperview().offset(-13)
//            $0.centerY.equalToSuperview().offset(-10)
//        })
        add(vStack).snp.makeConstraints({
            $0.left.equalToSuperview().offset(13)
            $0.top.equalToSuperview().offset(13)
            $0.bottom.equalToSuperview().offset(-10 - 13)
            $0.right.equalToSuperview().offset(-13)
//            $0.right.lessThanOrEqualTo(rightBtn.snp.left).offset(-10)
        })
        
        
        // 得算个高度 13 + 13 + 82
    }
    
    
    override func draw(_ rect: CGRect) {
        drawInContext(context: UIGraphicsGetCurrentContext()!)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
    }
    
    func drawInContext(context : CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.backgorundColor.cgColor)
        getDrawPath(context: context)
        context.fillPath()
    }
    
    func getDrawPath(context : CGContext) {
        let kArrorHeight = 10
        let rect = self.bounds
        let radius = 6.0
        let minx = rect.minX
        let midx = rect.midX
        let maxx = rect.maxX
        let miny = rect.minY
        let maxy = rect.maxY - 10
        
        context.move(to: CGPoint.init(x: midx + CGFloat(kArrorHeight), y: maxy))
        context.addLine(to: CGPoint.init(x: midx, y: maxy + CGFloat(kArrorHeight)))
        context.addLine(to: CGPoint.init(x: midx - CGFloat(kArrorHeight), y: maxy))
        
        context.addArc(tangent1End: CGPoint.init(x: minx, y: maxy), tangent2End: CGPoint.init(x: minx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint.init(x: minx, y: minx), tangent2End: CGPoint.init(x: maxx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint.init(x: maxx, y: miny), tangent2End: CGPoint.init(x: maxx, y: maxx), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint.init(x: maxx, y: maxy), tangent2End: CGPoint.init(x: midx, y: maxy), radius: CGFloat(radius))
        context.closePath();
    }
}
