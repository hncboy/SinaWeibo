//
//  WBHomeViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// 显示好友
    func showFriends() {
        print(#function)
        let vc = WBDemoViewController()
        // vc.hidesBottomBarWhenPushed = true //隐藏底部导航栏
        // push 的动作是 nav 做的
        navigationController?.pushViewController(vc, animated: true) //跳转页面
    }
}

// MARK: - 设置界面
extension WBHomeViewController {
    
    // 重写父类的方法
    override func setupUI() {
        super.setupUI()
        
        // 设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
    }
}
