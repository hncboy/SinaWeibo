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
