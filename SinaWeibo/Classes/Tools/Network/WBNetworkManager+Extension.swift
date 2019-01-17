//
//  WBNetworkManager+Extension.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/20.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension WBNetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - parameter since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    /// - parameter max_id: 返回ID小于或等于max_id的微博，默认为0。
    /// - parameter completion: 完成回调[List: 微博字典数组/是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool) -> ()) {
        
        // 用网络工具加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // Swift 中 Int 可以转换成 AnyObject 但是 Int64不行
        let params = ["since_id": "\(since_id)", "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            // 从json中获取statuses字典数组
            // 如果as?失败，result=nil
            // 服务器返回的字典数组，就是按照时间的倒序排序
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
    
    /// 返回新浪微博的未读数量
    func unreadCount(completion: @escaping (_ count: Int) -> ()) {
        
        guard let uid = uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
}


// MARK: - oAuth相关方法
extension WBNetworkManager {
     
    /// 加载AccessToken
    func loadAccessToken(code: String) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        // 发起网络
        request(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            print("json \(json)")
        }
    }
}
