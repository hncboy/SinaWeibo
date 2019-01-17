//
//  WBUserAccount.swift
//  SinaWeibo
//
//  Created by hncboy on 2019/1/16.
//  Copyright © 2019年 hncboy. All rights reserved.
//

import UIKit

private let accountFile: NSString = "useraccount.json"

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
    
    override init() {
        super.init()
        
        // 从磁盘加载保存的文件 -> 字典
        // 1>加载磁盘文件到二进制数据，如果失败直接返回
        guard let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
                return
        }
        
        // 2>使用字典设置属性值
        yy_modelSet(with: dict ?? [:])
        print("从沙盒加载用户信息 \(self)")
        
        // 3>判断token是否过期
        // 测试过期日期 - 开发中每一个分支都需要测试
        // expireDate = Date(timeIntervalSinceNow: -3600 * 24)
        // print(expireDate)
        
        if expireDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            
            // 清空token
            access_token = nil
            uid = nil
            
            // 删除账户文件
            _ = try? FileManager.default.removeItem(atPath: path)
        }

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
            let filePath = accountFile.cz_appendDocumentDir() else {
                
            return
        }
        // 3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功 \(filePath)")
    }
}
