//
//  CaijiModel.swift
//  BusinessDeer
//
//  Created by 梁泽 on 2021/3/25.
//

import SwiftComponents

public struct CaijiITemModel: InfoProtocol, Convertible {
    public enum Style {
        case 左标题_右标题, 左标题_输入框_右标题(_ rightTitle: String? = nil), 左标题_输入框, 左标题_请选择_右箭头
    }
    
    public init() { }
    
    public var key: String = ""
    public var value: String = ""
    
    public var style = Style.左标题_右标题
    
}
