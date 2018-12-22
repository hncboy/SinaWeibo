//
//  WBStatus.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/21.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class WBStatus: NSObject {

    /// Int类型，在64位的机器是64位的，在32位的机器是32位的
    var id: Int64 = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 重写description的计算属性
    override var description: String {
        return yy_modelDescription()
    }
}
