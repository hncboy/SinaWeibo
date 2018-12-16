//
//  WBBaseViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARk: - 设置界面
extension WBBaseViewController {
    
    func setupUI() {
       view.backgroundColor = UIColor.cz_random()
    }
}
