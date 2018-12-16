//
//  UIBarButtonItem+Extensions.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/16.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    /// 创建UIBarButtonItem
    ///
    /// - parameter title: title
    /// - parameter fontSize: fontSize，默认16号
    /// - parameter target: target
    /// - parameter action: action
    ///
    /// - returns: return value description
    convenience init(title: String , fontSize: CGFloat = 16, target: AnyObject?, action: Selector) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        // self.init实例化UIBarButtonItem
        self.init(customView: btn)
    }
}
