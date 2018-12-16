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
        
        // 设置导航栏按钮，无法高亮
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        
        // Swift调用OC返回instancetype的方法，判断不出是否可选
        let btn: UIButton = UIButton.cz_textButton("好友", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
}
