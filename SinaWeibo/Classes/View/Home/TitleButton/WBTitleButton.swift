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
            setTitle(title! + " ", for: [])
            
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
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews() // 一定要super
        
        // 判断 label 和 imageView 是否同时存在
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }
        
        print("\(titleLabel) \(imageView)")
        
        // 将 label 的 x 向左移动 imageView 的宽度
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        
        // 将 imageView 的 y 向右移动 label 的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }
}
