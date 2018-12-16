//
//  Bundle+Extenstions.swift
//  反射机制
//
//  Created by hncboy on 2018/12/12.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import Foundation

extension Bundle {
    
    //计算型属性类似于函数，没有参数，有返回值
    var namespace: String {
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
