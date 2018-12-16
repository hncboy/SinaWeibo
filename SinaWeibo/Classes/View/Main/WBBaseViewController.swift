//
//  WBBaseViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    /// 自定义的导航条目 - 以后设置导航栏内容，统一使用navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    /// 重写title的setter方法
    override var title: String? {
        
        didSet {
            navItem.title = title
        }
    }
}

// MARk: - 设置界面
extension WBBaseViewController {
    
    func setupUI() {
       view.backgroundColor = UIColor.cz_random()
        
        // 添加导航条
        view.addSubview(navigationBar)
        // 将item设置给bar
        navigationBar.items = [navItem]
        // 设置navBar的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
    }
}
