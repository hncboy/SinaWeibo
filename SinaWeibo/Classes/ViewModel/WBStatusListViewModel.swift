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
*/
class WBStatusListViewModel {
    
    /// 微博模型数组懒加载
    lazy var statusList = [WBStatus]()
    
    /// 加载微博列表
    ///
    /// - parameter completion：完成回调
    func loadStatus(completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        // since_id 取出数组中第一条微博的id
        let since_id = statusList.first?.id ?? 0
        

        WBNetworkManager.shared.statusList(since_id: since_id, max_id: 0) { (list, isSuccess) in
        
            // 1.字典转模型
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else {
                
                completion(isSuccess)
                return
            }
            
            print("刷新到 \(array.count) 条数据")
            
            // 2.FIXME: 拼接数据
            // 下拉刷新，应该将结果数组拼接在数组前面
            self.statusList = array + self.statusList
            
            // 3.完成回调
            completion(isSuccess)
        }
    }
}
