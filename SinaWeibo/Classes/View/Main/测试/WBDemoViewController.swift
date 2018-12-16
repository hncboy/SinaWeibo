//
//  WBDemoViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/16.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置标题
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
    }
    
    // MARK: - 监听方法
    /// 继续PUSH一个新的控制器
    func showNext() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBDemoViewController {
    
    /// 重写父类方法
    override func setupUI() {
        super.setupUI()
        
        // 设置右侧的控制器
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
