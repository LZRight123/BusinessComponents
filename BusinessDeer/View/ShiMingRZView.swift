//
//  File.swift
//  BusinessDeer
//
//  Created by 梁泽 on 2021/5/21.
//

import Foundation
import SwiftComponents

open class ShiMingRZView: LZView {
    public let tipLabel = UILabel(font: .font15, textColor: .init(hex: "#FC0000"), text: "请先完善身份证信息！")
    public let btn = UIButton(font: .font14, title: "立即认证", titleColor: .white, image: nil).then {
        $0.backgroundColor = .init(hex: "#FBB567")
    }
   
    
    open override var intrinsicContentSize: CGSize { .init(width: ScreenWidth, height: 48)}
    
    open override func setupUI() {
        backgroundColor = .init(hex: "#FFF6DF")
        btn.cornerRadius = 15
        add(btn).snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        
        add(tipLabel).snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(27)
        }
        
        
    }

}
