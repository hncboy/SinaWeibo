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
    /// - parameter isBack: 是否是返回按钮，如果是，加上箭头
    ///
    /// - returns: return value description
    convenience init(title: String , fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBack: Bool = false) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        // self.init实例化UIBarButtonItem
        self.init(customView: btn)
    }
}
