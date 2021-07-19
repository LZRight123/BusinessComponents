//
//  CustomMessage.swift
//  Deer
//
//  Created by liangze on 2020/8/14.
//  Copyright © 2020 zhuxiaoliang. All rights reserved.
//

import UIKit
@_exported import SwiftComponents

public protocol TimPushProtocol {
    var pushTitle: String { get set }
    var pushDesc: String { get set }
    var elmDesc: String { get set }
}

public typealias MessageBodyType = (Convertible & TimPushProtocol)

//MARK: - 自定义消息类型
public enum CustomMessageType: String, ConvertibleEnum, CaseIterable {
    case unkonw
    /// 聊天框支持商品链接自定义消息展示；点击可以解析出商品详情
    case productLink
    /// 健康问卷
    case jkwj
    /// 预警管理
    case measurementWarning
    /// 健康评估
    case healthAssessment
    //MARK: - 视频的类型
    /// 视频类型  重构时可以把下面合并
    ///  申请
    case invite = "videoInvite"
    ///   用户拒绝
    case refuse = "videoRefuse"
    ///    取消
    case cancel = "videoCancel"
    ///  挂断
    case stop = "videoStop"
    /// 出诊
    case videoComplete = "videoComplete"
    /// 医生拒绝出诊
    case doctorRefuse = "doctorRefuse"
    /// 用于标识该消息是视频申请超时未接通
    case videoTimeOut = "videoTimeOut"
    case 知识库 = "learnList"
    
    public func getDes() -> String {
        switch self {
        case .invite:
            return "[视频申请] 视频申请已发送..."
        case .refuse:
            return "[视频通话] 已拒绝视频..."
        case .cancel:
            return "[视频通话] 已取消视频..."
        case .stop:
            return "[视频通话] 已结束视频..."
        default: return ""
        }
    }
}



