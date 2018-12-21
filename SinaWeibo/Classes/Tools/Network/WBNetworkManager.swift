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
    static let shared = WBNetworkManager()
    
    /// 访问令牌，所有的网络请求，都基于此令牌(登录除外)
    var accessToken: String? = "2.00uAYETDxK1YXB9f69a8596bEEZzRC"
    
    /// 专门负责拼接token的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?,
        completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 处理token字典
        // 0>判断token是否为nil，为nil直接返回
        guard let token = accessToken else {
            print("没有token！需要登录")
            
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
