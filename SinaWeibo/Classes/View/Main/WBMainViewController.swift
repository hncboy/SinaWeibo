//
//  WBMainViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

/// 主控制器
class WBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeButton()
    }
    
    // MARK: - 监听方法
    /// 撰写微博
    // FIXME: 没有实现
    func composeStatus() {
        print("撰写微博")
    }
    
    // MARK: - 私有控件
    /// 撰写按钮
    lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
}
// extension 类似OC中的分类， 在Swift中还可以用来切分代码块
// 可以把相近功能的函数，放在一个extension中，便于代码维护，不能定义属性
// MARK: - 设置界面
extension WBMainViewController {
    
    func setupComposeButton() {
        tabBar.addSubview(composeButton)
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        // 将向内缩紧的宽度减少，能够让按钮的宽度变大，盖住容错点，防止穿帮
        let w = tabBar.bounds.width / count -  1
        
        // 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        print("撰写按钮宽度 \(composeButton.bounds.width)")
        
        // 按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    /// 设置所有子控制器
    func setupChildControllers() {
        
        let array = [
            ["clsName": "WBHomeViewController", "title": "首页", "imageName": "home"],
            ["clsName": "WBMessageViewController", "title": "消息", "imageName": "message_center"],
            ["clsName": "UIViewController"],
            ["clsName": "WBDiscoverViewController", "title": "发现", "imageName": "discover"],
            ["clsName": "WBProfileViewController", "title": "我", "imageName": "profile"]
        ]
        
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个子控制器
    /// - parameter dict: 信息字典[clsName, title, imageName]
    /// - returns: 子控制器
    private func controller(dict: [String: String]) -> UIViewController {
        // 1.取得字典内容
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else {
                
            return UIViewController()
        }
        
        // 2.创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        // 3.设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 4.设置tabbar的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        //系统默认是12号字，修改字体大小，要设置Normal的字体大小
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: UIControlState(rawValue: 0))
        
        let nav = WBNavigationController(rootViewController: vc)
        return nav
        
    }
}
    
