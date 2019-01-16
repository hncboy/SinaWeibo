//
//  WBStatusListViewModel.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/21.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import Foundation

/// 微博数据列表视图模型
/**
 父类的选择
 - 如果类需要使用 ‘KVC’ 或者字典转模型框架设置对象值，类就需要继承自NSObject
 - 如果类只是包装一些代码逻辑(写了一些函数)，可以不用任何父类
 
 负责微博的数据处理
 1.字典转模型
 2.下拉/上拉刷新数据处理
*/

/// 上拉刷新最大次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    
    /// 微博模型数组懒加载
    lazy var statusList = [WBStatus]()
    
    /// 上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - parameter pullup: 是否上拉刷新标记
    /// - parameter completion：完成回调[网络请求是否成功，是否刷新表格]
    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        // 判断是否是上拉刷新，同时检查刷新错误
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        // since_id 取出数组中第一条微博的id
        let since_id = pullup ? 0 : (statusList.first?.id ?? 0)
        // 上拉刷新，取出数组的最后一条微博的id
        let max_id = !pullup ? 0 : (statusList.last?.id ?? 0)

        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
        
            // 1.字典转模型
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else {
                
                completion(isSuccess, false)
                return
            }
            
            print("刷新到 \(array.count) 条数据")
            
            // 2.拼接数据
            if pullup {
                // 上拉刷新结束后，将结果拼接在数组的末尾
                self.statusList += array
            } else {
                // 下拉刷新，应该将结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            // 3.判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                // 4.完成回调
                completion(isSuccess, true)
            }
        }
    }
}
