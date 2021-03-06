//
//  WBNetworkManager.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/20.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit
import AFNetworking

/// Swift的枚举支持任意数据类型
enum WBHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {

    /// 静态区/常量/闭包
    /// 在第一次访问时，执行闭包，并且将结果保存在shared常量中
    static let shared: WBNetworkManager = {
        
        // 实例化对象
        let instance = WBNetworkManager()
        
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        // 返回对象
        return instance
    }()
    
    /// 用户账户的懒加载属性
    lazy var userAccount = WBUserAccount()
    
    /// 用户登录标记[计算型属性]
    var userLogin: Bool {
        return userAccount.access_token != nil
    }
    
    /// 专门负责拼接token的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?,
        completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 处理token字典
        // 0>判断token是否为nil，为nil直接返回，程序执行过程中，一般 token 不会为 nil
        guard let token = userAccount.access_token else {
            // 发送通知，提示用户登录
            print("没有token！需要登录")
            
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                object: nil)
            
            completion(nil, false)
            return
        }
        
        // 1>判断参数字典是否存在，如果为nil，新建一个字典
        var parameters = parameters
        if parameters == nil {
            // 实例化字典
            parameters = [String: AnyObject]()
        }
        
        // 2>设置参数字典，代码在此处一定有值
        parameters!["access_token"] = token as AnyObject?
        
        // 调用request发起真正的网络请求方法
        request(URLString: URLString, parameters: parameters!, completion: completion)
    }
    
    /// 使用一个函数封装AFN的GET/POST请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 完成回调[json(字典/数组), 是否成功]
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject], completion:
        @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(json as AnyObject?, true)
        }
        
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            
            // 针对403处理用户token过期
            // 对于测试用户每天的刷新数量是有限的
            // 超出上限，token会被锁定一段时间，需要新建一个应用程序
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                // 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理)
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                    object: "bad token")
            }
            
            print("网络请求错误 \(error)")
            completion(nil, true)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
