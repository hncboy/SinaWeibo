//
//  WBVisitorView.swift
//  SinaWeibo
//
//  Created by hncboy on 2018/12/19.
//  Copyright © 2018年 hncboy. All rights reserved.
//

import UIKit

/// 访客视图
class WBVisitorView: UIView {

    /// 访客视图的信息字典 [imageName / message]
    /// 如果是首页 imageName == ""
    var visitorInfo: [String: String]? {
        didSet {
            // 1>取字典信息
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            // 2>设置消息
            tipLabel.text = message
            
            // 3>设置图像，首页不需要设置
            if imageName == "" {
                return
            }
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 私有控件
    /// 懒加载属性只有调用UIKit控件的指定构造函数不需要使用类型
    /// 图像视图
    lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    /// 遮罩图像
    lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    /// 小房子
    lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    /// 提示标签
    lazy var tipLabel: UILabel = UILabel.cz_label(
        withText: "先去关注一些人吧，再来看看有什么惊喜先去关注一些人吧，再来看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)
    
    /// 注册按钮
    lazy var registerButton: UIButton = UIButton.cz_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    /// 登录按钮
    lazy var loginButton: UIButton = UIButton.cz_textButton(
        "登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
}

// MARK: - 设置界面
extension WBVisitorView {
    
    func setupUI() {
        // 0.能够使用颜色，就不用图像
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        // 1.添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 2.取消autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 3.自动布局
        let margin: CGFloat = 20.0
        
        // 1>图像识别
        addConstraint(NSLayoutConstraint(item: iconView, //视图
                                         attribute: .centerX, //约束属性
                                         relatedBy: .equal, //约束关系
                                         toItem: self, //参照视图
                                         attribute: .centerX, //参照属性
                                         multiplier: 1.0, //乘积
                                         constant: 0)) //约束数值
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        // 2>小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        // 3>提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 260))
        // 4>注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        // 5>登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        // 6>遮罩图像
        // views: 定义VFL中的控件名称和实际名称映射关系
        // metrics: 定义VFL中()指定的常数影射关系
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : Any]
        let metrics = ["spacing": 20]
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))
    }
}
