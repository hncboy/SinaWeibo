//
//  WBWelcomeView.swift
//  SinaWeibo
//
//  Created by hncboy on 2019/1/17.
//  Copyright © 2019年 hncboy. All rights reserved.
//

import UIKit

/// 欢迎视图
class WBWelcomeView: UIView {

    class func welcomeView() -> WBWelcomeView {
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        
        // 从 XIB 加载的视图默认是 600*600 的
        v.frame = UIScreen.main.bounds
        
        return v
    }
}
