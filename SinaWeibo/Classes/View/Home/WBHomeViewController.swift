//
//  WBHomeViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/14.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

//定义全局常量
private let cellId = "cellId"

class WBHomeViewController: WBBaseViewController {

    /// 微博数据数组
    var statusList = [String]()
    
    /// 加载数据
    override func loadData() {
        
        print("开始加载数据 \(WBNetworkManager.shared)")
        
        // 模拟延时加载数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            
            for i in 0..<15 {
                if self.isPullup {
                    // 将数据追加到底部
                    self.statusList.append("上拉 \(i)")
                } else {
                    // 将数据插入到数组的顶部
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            print("加载数据结束")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            
            // 恢复上拉刷新标记
            self.isPullup = false
            
            // 刷新表格
            self.tableView?.reloadData()
        })
       
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

// MARK: - 表格数据源方法，具体的数据源方法实现，不需要super
extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        // 2.设置cell
        cell.textLabel?.text = statusList[indexPath.row]
        // 3.返回cell
        return cell
    }
}

// MARK: - 设置界面
extension WBHomeViewController {
    
    /// 重写父类的方法
    override func setupTableView() {
        super.setupTableView()
        
        // 设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册原型cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
