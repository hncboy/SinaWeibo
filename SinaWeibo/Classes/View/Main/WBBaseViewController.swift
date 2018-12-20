//
//  WBBaseViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

// 多继承
//class WBBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
// Swift中，利用extension，可以把函数按照功能分类管理，便于阅读和维护
// 注意：
// 1.extension中不能有属性
// 2.extension中不能重写父类方法！重写父类方法，是子类的指责，扩展是对类的扩展

class WBBaseViewController: UIViewController {
    
    /// 表格视图 - 如果用户没有登录，就不创建
    var tableView: UITableView?
    
    /// 刷新控件
    var refreshControl: UIRefreshControl?
    
    /// 上拉刷新标记
    var isPullup = false
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    /// 自定义的导航条目 - 以后设置导航栏内容，统一使用navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }

    /// 重写title的setter方法
    override var title: String? {
        
        didSet {
            navItem.title = title
        }
    }
    
    /// 加载数据 - 具体的实现由子类负责
    func loadData() {
        
    }
}

// MARk: - 设置界面
extension WBBaseViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        
        // 取消自动缩进 - 隐藏导航栏会缩进20个点
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        setupTableView()
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源&代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height,
                                               left: 0,
                                               bottom: tabBarController?.tabBar.bounds.height ?? 49,
                                               right: 0)
        
        // 设置刷新控件
        // 1>实例化控件
        refreshControl = UIRefreshControl()
        // 2>添加到表格视图
        tableView?.addSubview(refreshControl!)
        // 3>添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        // 添加导航条
        view.addSubview(navigationBar)
        // 将item设置给bar
        navigationBar.items = [navItem]
        // 设置navBar的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        // 设置navBar的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WBBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法，子类负责具体的实现
    // 子类的数据源方法不需要super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 只保证无语法错误
        return UITableViewCell()
    }
    
    /// 在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 1.判断indexPath是否是最后一行
        // indexPath.section最大  /  indexPath.row最后一行
        // 1>row
        let row = indexPath.row
        // 2>section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        // 3>行数
        let count = tableView.numberOfRows(inSection: section)
        
        // 如果是最后一行，且没有开始上拉刷新
        if row == (count - 1) && !isPullup {
            print("上拉刷新")
        }
    }
}
