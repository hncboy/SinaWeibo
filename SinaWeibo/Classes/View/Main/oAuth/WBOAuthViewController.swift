//
//  WBOAuthViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2019/1/16.
//  Copyright © 2019年 hncboy. All rights reserved.
//

import UIKit

/// 通过webView加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        
        // 设置导航栏
        title = "登录新浪微博"
        // 导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        // 1>URL确定要访问的资源
        guard let url = URL(string: urlString) else {
            return
        }
        
        // 2>建立请求
        let request = URLRequest(url: url)
        
        // 3>加载请求
        webView.loadRequest(request)
    }
    
    // MARK: - 监听方法
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充 - WebView的注入，直接通过js修改 本地浏览器中 缓存的页面内容
    /// 点击登录按钮，执行submit()，将本地数据提交给服务器
    func autoFill() {
        // 准备js
        let js = "document.getElementById('userId').value = '18758341899';" + "document.getElementById('passwd').value = 'hu18758341899';"
        
        // 让webview执行js
        webView.stringByEvaluatingJavaScript(from: js)
    }
}
