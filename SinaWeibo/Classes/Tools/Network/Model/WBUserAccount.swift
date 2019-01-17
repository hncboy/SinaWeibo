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
    
    /**
     1.偏好设置（小）- Xcode 8 beta 无效
     2.沙盒 - 归档/plist/json
     3.数据库（FMDB/CoreData）
     4.钥匙串访问（小/自动加密-需要使用框架 SSKeychain）
    */
    func saveAccount() {
        
        // 1.模型转字典
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        
        // 需要删除expires_in值
        dict.removeValue(forKey: "expires_in")
        
        // 2.字典序列化data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = ("useraccount.json" as NSString).cz_appendDocumentDir() else {
                
            return
        }
        // 3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功 \(filePath)")
    }
}
