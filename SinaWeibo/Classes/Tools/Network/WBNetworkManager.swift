//
//  WBNetworkManager.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/20.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit
import AFNetworking

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {

    /// 静态区/常量/闭包
    /// 在第一次访问时，执行闭包，并且将结果保存在shared常量中
    static let shared = WBNetworkManager()
}
