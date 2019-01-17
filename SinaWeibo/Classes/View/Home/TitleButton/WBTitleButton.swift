//
//  WBTitleButton.swift
//  SinaWeibo
//
//  Created by hncboy on 2019/1/17.
//  Copyright © 2019年 hncboy. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

    /// 重载构造函数
    /// title 如果是 nil, 就显示首页
    /// 如果不为 nil，显示 title 和箭头图像
    init(title: String?) {
        super.init(frame: CGRect())
        
        // 1>判断 title 是否为 nil
        if title == nil {
            setTitle("首页", for: [])
        } else {
            setTitle(title!, for: [])
            
            // 设置图像
            setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        // 2>设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        
        // 3>设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
