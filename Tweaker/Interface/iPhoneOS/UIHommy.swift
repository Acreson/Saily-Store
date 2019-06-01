//
//  UIHommy.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIHommyS: UIViewController {
    
    var container: UIScrollView?
    var header_view: UIView?
    
    // 控制 NAV
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    } // viewWillAppear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    } // viewWillDisappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 先放一个 scrollview 放，且谨放一次
        if container == nil {
            container = UIScrollView()
            view.addSubview(container!)
        }
        
        // 处理一下头条
        let header = LKRoot.ins_view_manager.create_AS_home_header_view()
        container!.addSubview(header)
        header_view = header
        
        // 为所有不可删除 view 打 tag
        for item in view.subviews {
            item.tag = view_tags.must_have.rawValue
        }
        
        // 处理 AutoLayout
        self.container?.snp.makeConstraints({ (x) in
            x.top.equalTo(self.view.safeAreaInsets.top)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.bottom.equalTo(self.view.safeAreaInsets.bottom)
        })
        header.snp.makeConstraints({ (x) in
            x.top.equalTo(self.container!.snp.top)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(100)
        })
        
        // 发送到加载
        build_view()
        
    } // viewDidLoad
    
    func build_loading(in_where: UIView) {
        let loading = UIActivityIndicatorView()
        loading.startAnimating()
        loading.color = LKRoot.ins_color_manager.read_a_color("main_tint_color")
        loading.tag = view_tags.indicator.rawValue
        view.addSubview(loading)
        let loading_label = UILabel()
        loading_label.text = "- 正在加载 -".localized()
        loading_label.textColor = LKRoot.ins_color_manager.read_a_color("main_tint_color")
        loading_label.font = UIFont(name: ".SFUIText-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        loading_label.tag = view_tags.indicator.rawValue
        view.addSubview(loading_label)
        loading.snp.makeConstraints { (x) in
            x.centerY.equalTo(in_where.snp.centerY).offset(38)
            x.centerX.equalTo(in_where.snp.centerX).offset(0)
        }
        loading_label.snp.makeConstraints { (x) in
            x.centerY.equalTo(in_where.snp.centerY).offset(58)
            x.centerX.equalTo(in_where.snp.centerX).offset(0)
        }
    } // build_loading
    
    @objc func build_view() {
        
        for item in view.subviews where item.tag != view_tags.must_have.rawValue {
            item.removeFromSuperview()
        }
        
        // 处理一下正在加载 😂
        build_loading(in_where: view)
        
        // 检查联网
        if LKRoot.ins_common_operator.test_network() == operation_result.failed.rawValue {
            
            for item in view.subviews where item.tag == view_tags.indicator.rawValue {
                item.removeFromSuperview()
            }
            
            let retry_button = UIButton()
            retry_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_tint_color"), for: .normal)
            retry_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("button_touched_color"), for: .highlighted)
            retry_button.setTitle("无网络连接 点这里重试".localized(), for: .normal)
            retry_button.addTarget(self, action: #selector(build_view), for: .touchUpInside)
            view.addSubview(retry_button)
            retry_button.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.view.snp.centerX)
                x.centerY.equalTo(self.view.snp.centerY).offset(66)
            }
            
            let label = UILabel()
            label.text = "!"
            label.font = UIFont(name: ".SFUIText-Semibold", size: 88) ?? UIFont.systemFont(ofSize: 88)
            label.textAlignment = .center
            label.textColor = LKRoot.ins_color_manager.read_a_color("button_touched_color")
            view.addSubview(label)
            label.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.view.snp.centerX)
                x.centerY.equalTo(self.view.snp.centerY).offset(0)
            }
            
            return
        }
        
        print("[*] 开始加载今日精选。")
        LKRoot.queue_dispatch.async {
            LKRoot.ins_common_operator.NP_sync_and_download(CallB: { (ret) in
                if ret == 0 {
                    print("[*] 开始构建主页面")
                    DispatchQueue.main.async {
                        
                        // 删除加载指示
                        for item in self.view.subviews where item.tag == view_tags.indicator.rawValue {
                            item.removeFromSuperview()
                        }
                        
                        // 调整主容器大小
                        self.container?.contentSize.height = CGFloat(LKRoot.container_news_repo.count * 425) + 128
                        
                        let debugger = LKRoot.container_news_repo
                        print(debugger)
                        
                        // 第一个源的瞄点
                        var last_view = UIView()
                        if self.header_view != nil {
                            last_view = self.header_view!
                        }
                        // 创建卡片组
                        let card_width = UIScreen.main.bounds.width - 55
                        for repo in LKRoot.container_news_repo {
                            // 创建View
                            let new_view = UIView()
                            self.container?.addSubview(new_view)
                            new_view.snp.makeConstraints({ (x) in
                                x.top.equalTo(last_view.snp.bottom).offset(8)
                                x.left.equalTo(self.view.snp.left)
                                x.right.equalTo(self.view.snp.right)
                                x.height.equalTo(415)
                            })
                            // 小标题
                            let small_title = UILabel(text: repo.sub_title)
                            small_title.font = UIFont(name: ".SFUIText-Semibold", size: 11) ?? UIFont.systemFont(ofSize: 11)
                            if let color = UIColor(hexString: repo.subtitle_color) {
                                small_title.textColor = color
                            } else {
                                small_title.textColor = LKRoot.ins_color_manager.read_a_color("main_tint_color")
                            }
                            new_view.addSubview(small_title)
                            small_title.snp.makeConstraints({ (x) in
                                x.top.equalTo(new_view.snp.top).offset(18)
                                x.left.equalTo(new_view.snp.left).offset(38)
                            })
                            // 大标题
                            let big_title = UILabel(text: repo.title)
                            big_title.font = UIFont(name: ".SFUIText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22)
                            if let color = UIColor(hexString: repo.title_color) {
                                big_title.textColor = color
                            } else {
                                big_title.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
                            }
                            new_view.addSubview(big_title)
                            big_title.snp.makeConstraints({ (x) in
                                x.top.equalTo(small_title.snp.bottom).offset(2)
                                x.left.equalTo(small_title.snp.left).offset(0)
                            })
                            // 容器
                            let cards_container = UIScrollView()
                            cards_container.contentSize = CGSize(width: CGFloat(repo.cards.count) * (card_width + 27.5) + 27.5, height: 350)
                            new_view.addSubview(cards_container)
                            cards_container.snp.makeConstraints({ (x) in
                                x.height.equalTo(360)
                                x.left.equalTo(self.view.snp.left)
                                x.right.equalTo(self.view.snp.right)
                                x.top.equalTo(big_title.snp.bottom).offset(8)
                            })
                            
                            // 添加卡片
                            var last_card = UIView()    // 定位片
                            cards_container.addSubview(last_card)
                            last_card.snp.makeConstraints({ (x) in
                                x.width.equalTo(0)
                                x.height.equalTo(360)
                                x.top.equalTo(cards_container.snp.top).offset(0)
                                x.left.equalTo(cards_container.snp.left).offset(0)
                            })
                            for card in repo.cards {    // 开始添加
                                let new_card_container = UIView()
                                new_card_container.setRadius(radius: 8)
                                new_card_container.addShadow(ofColor: UIColor(hexString: "0x9A9A9A")!)
                                new_card_container.clipsToBounds = false
                                cards_container.addSubview(new_card_container)
                                new_card_container.snp.makeConstraints({ (x) in
                                    x.top.equalTo(cards_container.snp.top).offset(10)
                                    x.left.equalTo(last_card.snp.right).offset(27.5)
                                    x.width.equalTo(card_width)
                                    x.height.equalTo(360 - 20)
                                })
                                let new_card = LKRoot.ins_view_manager.NPCD_create_card(info: card)
                                new_card.setRadius(radius: 8)
                                new_card_container.addSubview(new_card)
                                new_card.snp.makeConstraints({ (x) in
                                    x.top.equalTo(new_card_container.snp.top).offset(0)
                                    x.left.equalTo(new_card_container.snp.left).offset(0)
                                    x.right.equalTo(new_card_container.snp.right).offset(0)
                                    x.bottom.equalTo(new_card_container.snp.bottom).offset(0)
                                })
                                last_card = new_card_container
                            }
                            
                            // 移动瞄点
                            last_view = new_view
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        for item in self.view.subviews where item.tag == view_tags.indicator.rawValue {
                            item.removeFromSuperview()
                        }
                        
                        let retry_button = UIButton()
                        retry_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_tint_color"), for: .normal)
                        retry_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("button_touched_color"), for: .highlighted)
                        retry_button.setTitle("加载失败 点击重试".localized(), for: .normal)
                        retry_button.addTarget(self, action: #selector(self.build_view), for: .touchUpInside)
                        self.view.addSubview(retry_button)
                        retry_button.snp.makeConstraints { (x) in
                            x.centerX.equalTo(self.view.snp.centerX)
                            x.centerY.equalTo(self.view.snp.centerY).offset(66)
                        }
                        
                        let label = UILabel()
                        label.text = "!"
                        label.font = UIFont(name: ".SFUIText-Semibold", size: 88) ?? UIFont.systemFont(ofSize: 88)
                        label.textAlignment = .center
                        label.textColor = LKRoot.ins_color_manager.read_a_color("button_touched_color")
                        self.view.addSubview(label)
                        label.snp.makeConstraints { (x) in
                            x.centerX.equalTo(self.view.snp.centerX)
                            x.centerY.equalTo(self.view.snp.centerY).offset(0)
                        }
                    } // DispatchQueue
                } // if
            })
        }
        
    } // build_view
    
}
