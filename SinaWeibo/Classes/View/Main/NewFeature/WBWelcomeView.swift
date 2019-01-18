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
    
    
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    class func welcomeView() -> WBWelcomeView {
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        
        // 从 XIB 加载的视图默认是 600*600 的
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    /// 视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口时，根据父视图的大小，计算约束值，更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在位置，就是 XIB 中国布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        // 如果控件们的 frame 还没有计算好，所有的约束会一起动画
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                
                // 更新约束
                self.layoutIfNeeded()
        }) { (_) in
            
        }
    }
}

