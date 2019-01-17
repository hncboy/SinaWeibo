//
//  WBOAuthViewController.swift
//  SinaWeibo
//
//  Created by hncboy on 2019/1/16.
//  Copyright © 2019年 hncboy. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过webView加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        
        // 取消滚动视图
        webView.scrollView.isScrollEnabled = false
        
        // 设置代理
        webView.delegate = self
        
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
    /// 关闭控制器
    func close() {
        SVProgressHUD.dismiss()
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

extension WBOAuthViewController: UIWebViewDelegate {
    
    /// webView将要加载请求
    ///
    /// - parameter webView: webView
    /// - parameter request: 要加载的请求
    /// - parameter navigationType: 导航类型
    ///
    /// - returns: 是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.如果请求地址包含 http://baidu.com 不加载页面/否则加载页面
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        //print("加载请求 --- \(request.url?.absoluteString)")
        // query就是URL中'?'后面的所有部分
        //print("加载请求 --- \(request.url?.query)")
        // 2.从 http://baidu.com 回调地址的查询字符串中查找 'code='
        // 如果有，授权成功，否则，授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        // 3.从query字符串中取出授权码
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("授权码 - \(code)")
        
        // 4.使用授权码获取[换取]AccessToken
        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in

            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
              
                // 1>发送通知 - 不关心有没有监听者
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
                // 2>关闭窗口
                self.close()
            }
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
