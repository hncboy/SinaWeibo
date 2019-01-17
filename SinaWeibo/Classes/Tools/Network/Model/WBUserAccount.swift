//
//  WBUserAccount.swift
//  SinaWeibo
//
//  Created by hncboy on 2019/1/16.
//  Copyright © 2019年 hncboy. All rights reserved.
//

import UIKit

/// 用户账户信息
class WBUserAccount: NSObject {

    /// 访问令牌
    var access_token: String? //= "2.00uAYETDpFN57Bec46ea6226kKSh1B"
    /// 用户代号
    var uid: String?
    /// 过期日期，单位秒
    /// 开发者 5 年
    /// 使用者 3 天
    var expires_in: TimeInterval = 0.0 {
        
        didSet {
            expireDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    var expireDate: Date?
    
    override var description: String {
        return yy_modelDescription()
    }
}
