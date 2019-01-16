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
    
    // 定时器
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        setupComposeButton()
        setupTimer()
        
        // 设置代理
        delegate = self
    }
    
    deinit {
        // 销毁时钟
        timer?.invalidate()
    }
    
    /**
     portrait: 竖屏
     landscape: 横屏
     
     - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向
     - 播放视频的话，用modal展现
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    // MARK: - 监听方法
    /// 撰写微博
    // FIXME: 没有实现
    //
    func composeStatus() {
        print("撰写微博")
        
        // 测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.cz_random()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 私有控件
    /// 撰写按钮
    lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
}

// MARK: - UITabBarControllerDelegate
extension WBMainViewController: UITabBarControllerDelegate {
    
    /// 将要选择 TabBarItem
    ///
    /// - parameter tabBarController: tabBarController
    /// - parameter viewController: 目标控制器
    ///
    /// - returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        print("将要切换到 \(viewController)")
        
        // 1>获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        // 2>判断当前索引是首页，同时idx也是首页，重复点击首页的按钮
        if selectedIndex == 0 && idx == selectedIndex {
            print("点击首页")
            // 3>让表格滚动到顶部
            // a) 获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            // b) 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            // 4>刷新数据
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
        }
        
        
        // 判断目标控制器是否是 UIViewController
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 时钟相关方法
extension WBMainViewController {
    
    /// 定义时钟
    func setupTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        
        if !WBNetworkManager.shared.userLogin {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            
            print("检测到 \(count) 条新微博")
            
            // 设置 首页 tabBarItem 的badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            // 设置App的badgeNumber，从IOS8.0之后，要用户授权之后才能够显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// extension 类似OC中的分类， 在Swift中还可以用来切分代码块
// 可以把相近功能的函数，放在一个extension中，便于代码维护，不能定义属性
// MARK: - 设置界面
extension WBMainViewController {
    
    func setupComposeButton() {
        tabBar.addSubview(composeButton)
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        // 将向内缩紧的宽度
        let w = tabBar.bounds.width / count
        
        // 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        //print("撰写按钮宽度 \(composeButton.bounds.width)")
        
        // 按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    /// 设置所有子控制器
    func setupChildControllers() {
        
        // 0.获取沙盒json的路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")

        // 加载data
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断data是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil {
            // 从bundle加载配置的json
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        // data一定有内容
        // 反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as! [[String: AnyObject]] else {
            return
        }
       
        // 界面的创建依赖网络的json
        /*let array: [[String: AnyObject]] = [
            ["clsName": "WBHomeViewController" as AnyObject, "title": "首页" as AnyObject, "imageName": "home" as AnyObject,
                "visitorInfo": ["imageName": "", "message": "关注一些人，回这里看看有什么惊喜"] as AnyObject
            ],
            ["clsName": "WBMessageViewController" as AnyObject, "title": "消息" as AnyObject, "imageName": "message_center" as AnyObject,
                "visitorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"] as AnyObject
            ],
            ["clsName": "UIViewController" as AnyObject],
            ["clsName": "WBDiscoverViewController" as AnyObject, "title": "发现" as AnyObject, "imageName": "discover" as AnyObject,
                "visitorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"] as AnyObject
            ],
            ["clsName": "WBProfileViewController" as AnyObject, "title": "我" as AnyObject, "imageName": "profile" as AnyObject,
                "visitorInfo": ["imageName": "visitordiscover_image_profile", "message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人看"] as AnyObject
            ]
        ]*/
        
        // 测试数据格式是否正确，转换成plist数据更加直观
        // (array as NSArray).write(toFile: "/Users/hncboy/Desktop/demo.plist", atomically: true)
        // 数组 -> json序列化
        // let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
        // (data as NSData).write(toFile: "/Users/hncboy/Desktop/demo.json", atomically: true)
        
        // 遍历数组，循环创建控制器数组
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        
        // 设置tabBar的子控制器
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个子控制器
    /// - parameter dict: 信息字典[clsName, title, imageName]
    /// - returns: 子控制器
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        
        // 1.取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String: String] else {
                
                return UIViewController()
        }
        
        // 2.创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        // 设置控制器的访客信息字典
        vc.visitorInfoDictionary = visitorDict
        
        // 3.设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 4.设置tabbar的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        //系统默认是12号字，修改字体大小，要设置Normal的字体大小
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: UIControlState(rawValue: 0))
        
        // 实例化导航控制器的时候，会调用push方法将rootViewController压栈
        let nav = WBNavigationController(rootViewController: vc)
        return nav
        
    }
}
    
