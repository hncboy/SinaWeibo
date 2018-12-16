//
//  WBNavigationControllerViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隐藏默认的NavigationBar
        navigationBar.isHidden = true
    }
    
    /// 重写push方法
    /// viewController是被push的控制器，设置他的左侧按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            // 隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
            
            // 判断控制器的类型
            if let vc = viewController as? WBBaseViewController {
                
                var title = "返回"
                
                // 判断控制器级数，只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    // title 显示首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                // 取出自定义的navItem
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent))
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    /// POP 返回到上一级控制器
    @objc private func popToParent() {
        popViewController(animated: true)
        
    }
}
