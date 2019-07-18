//
//  LKPackageDetail.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/17.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import WebKit
import JJFloatingActionButton

class LKPackageDetail: UIViewController {
    
    public var item: DBMPackage = DBMPackage()
    private var theme_color = UIColor()
    private var theme_color_bak = UIColor()
    private var tint_color_consit = false
    private var contentView = UIScrollView()
    
    let status_bar_cover = UIView()
    let banner_image = UIImageView()
    let banner_section = common_views.LKIconBannerView()
//    let section_headers = [common_views.LKSectionBeginHeader]()
    
    var currentAnchor = UIView()
    
    var img_initd = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if LKRoot.settings?.use_dark_mode ?? false {
            navigationController?.navigationBar.barStyle = .blackOpaque
        } else {
            navigationController?.navigationBar.barStyle = .default
        }
        
        view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_background")
        
        // 校验软件包数据合法性
        if item.version.count != 1 {
            presentStatusAlert(imgName: "Warning", title: "错误".localized(), msg: "软件包信息校验失败，请尝试刷新。".localized())
            title = "错误".localized()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        //              版本号        源地址
        if item.version.first!.value.count != 1 {
            presentStatusAlert(imgName: "Warning", title: "错误".localized(), msg: "软件包信息校验失败，请尝试刷新。".localized())
            title = "错误".localized()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        // 检查是否存在 Sileo 死了哦的皮孙 Depiction
        var dep: String?
        var dep_type = ""
        if item.version.first?.value.first?.value["SileoDepiction".uppercased()] != nil {
            dep = item.version.first?.value.first?.value["SileoDepiction".uppercased()]!
            dep_type = "Sileo"
        } else if item.version.first?.value.first?.value["Depiction".uppercased()] != nil {
            dep = item.version.first?.value.first?.value["Depiction".uppercased()]!
            dep_type = "Cydia"
        } else {
            dep = item.version.first?.value.first?.value["Description".uppercased()]
            dep_type = "none"
        }
        
        // --------------------- 开始处理你的脸！
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        theme_color = LKRoot.ins_color_manager.read_a_color("main_tint_color")
        theme_color_bak = LKRoot.ins_color_manager.read_a_color("main_background")
        
        edgesForExtendedLayout = .top
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(contentView)
        contentView.delegate = self
        contentView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.contentOffset = CGPoint(x: 0, y: 0)
        contentView.contentInsetAdjustmentBehavior = .never
        contentView.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
        contentView.contentSize = CGSize(width: 0, height: 1888)
        
        status_bar_cover.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_background")
        view.addSubview(status_bar_cover)
        status_bar_cover.snp.makeConstraints { (x) in
            x.top.equalTo(self.view.snp.top)
            x.height.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
        }
        
        contentView.addSubview(banner_image)
        banner_image.contentMode = .scaleAspectFill
        banner_image.snp.makeConstraints { (x) in
            x.top.lessThanOrEqualTo(self.contentView.snp.top)
            x.top.lessThanOrEqualTo(self.view.snp.top)
            x.left.equalTo(view.snp.left)
            x.right.equalTo(view.snp.right)
            x.height.lessThanOrEqualTo(233)
            x.height.equalTo(233)
            x.bottom.equalTo(self.contentView.snp.top).offset(233)
        }
        
        banner_image.clipsToBounds = true
        // 获取图标
        let d1 = UIImageView()
        let icon_addr = item.version.first?.value.first?.value["ICON"] ?? ""
        d1.sd_setImage(with: URL(string: icon_addr)) { (img, _, _, _) in
            if img != nil && !self.img_initd {
                let color = img!.getColors()?.background ?? .white
                self.banner_image.backgroundColor = color
                if color.red + color.blue + color.green > 2.6 {
                    self.tint_color_consit = true
                }
            } else {
                let color = UIImage(named: TWEAK_DEFAULT_IMG_NAME)?.getColors()?.background ?? .white
                self.banner_image.backgroundColor = color
                if color.red + color.blue + color.green > 2.6 {
                    self.tint_color_consit = true
                }
            }
            self.updateColor()
        }
        
        contentView.addSubview(banner_section)
        banner_section.snp.makeConstraints { (x) in
            x.top.equalTo(banner_image.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(98)
        }
        banner_section.icon.sd_setImage(with: URL(string: icon_addr), placeholderImage: UIImage(named: TWEAK_DEFAULT_IMG_NAME))
        banner_section.title.text = LKRoot.ins_common_operator.PAK_read_name(version: item.version.first?.value ?? LKRoot.ins_common_operator.PAK_return_error_vision())
        title = banner_section.title.text
        banner_section.sub_title.text = LKRoot.ins_common_operator.PAK_read_auth(version: item.version.first?.value ?? LKRoot.ins_common_operator.PAK_return_error_vision()).0
        banner_section.button.setTitle("操作".localized(), for: .normal)
        banner_section.button.backgroundColor = theme_color
        banner_section.button.setTitleColor(theme_color_bak, for: .normal)
        banner_section.apart_init() // sizeThatFit 需要先放文字
        
        // 防止抽风
        DispatchQueue.main.async {
            self.scrollViewDidScroll(self.contentView)
        }
        
        currentAnchor = banner_section
        
        switch dep_type {
        case "none":
            setup_none(dep: dep ?? "")
        case "Sileo":
            setup_Sileo(dep: dep ?? "")
        case "Cydia":
            IHProgressHUD.show()
            
        default:
            fatalError("你这是啥子情况啊？")
        }
        
    }
    
    func setup_none(dep: String) {
        let text = UITextView()
        text.backgroundColor = .clear
        text.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        text.font = .boldSystemFont(ofSize: 16)
        text.text = dep
        text.isUserInteractionEnabled = false
        contentView.addSubview(text)
        text.snp.makeConstraints { (x) in
            x.top.equalTo(self.banner_section.snp.bottom).offset(38)
            x.left.equalTo(self.view.snp.left).offset(38)
            x.right.equalTo(self.view.snp.right).offset(-38)
            x.height.equalTo(666)
        }
        let text2 = UITextView()
        text2.backgroundColor = .clear
        text2.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        text2.font = .boldSystemFont(ofSize: 10)
        text2.isUserInteractionEnabled = false
        var read = "因出现未知错误现提供软件包的原始信息：\n\n".localized()
        let depsss = item.version.first?.value.first?.value ?? ["未知错误".localized() : "无更多信息".localized()]
        for item in depsss.keys.sorted() {
            read.append(item)
            read.append(": ")
            read.append("\n")
            read.append(depsss[item] ?? "")
            read.append("\n")
            read.append("\n")
        }
        text2.text = read
        contentView.addSubview(text2)
        text2.snp.makeConstraints { (x) in
            x.top.equalTo(text.snp.bottom).offset(38)
            x.left.equalTo(self.view.snp.left).offset(38)
            x.right.equalTo(self.view.snp.right).offset(-38)
            x.height.equalTo(666)
        }
        DispatchQueue.main.async {
            let height = text.sizeThatFits(CGSize(width: text.frame.width, height: .infinity)).height
            text.snp.remakeConstraints { (x) in
                x.top.equalTo(self.banner_section.snp.bottom).offset(38)
                x.left.equalTo(self.view.snp.left).offset(38)
                x.right.equalTo(self.view.snp.right).offset(-38)
                x.height.equalTo(height)
            }
            let height2 = text2.sizeThatFits(CGSize(width: text2.frame.width, height: .infinity)).height
            text2.snp.remakeConstraints { (x) in
                x.top.equalTo(text.snp.bottom).offset(38)
                x.left.equalTo(self.view.snp.left).offset(38)
                x.right.equalTo(self.view.snp.right).offset(-38)
                x.height.equalTo(height2)
            }
            self.contentView.contentSize.height = CGFloat(400) + height + height2
        }
    }
    
    func setup_Sileo(dep: String) {
        // 获取数据
        if let url = URL(string: dep) {
            IHProgressHUD.show()
            AF.request(url, method: .get, headers: nil).response(queue: LKRoot.queue_dispatch) { (responed) in
                var read = String(data: responed.data ?? Data(), encoding: .utf8) ?? ""
                if read == "" {
                    read = String(data: responed.data ?? Data(), encoding: .ascii) ?? ""
                }
                if read == "" {
                    DispatchQueue.main.async {
                        IHProgressHUD.dismiss()
                        self.setup_none(dep: "获取描述数据失败，请检查网络连接。".localized())
                    }
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: read.data(using: .utf8)!, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            IHProgressHUD.dismiss()
                            self.doJsonSetupLevelRoot(json: json)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        IHProgressHUD.dismiss()
                        self.setup_none(dep: "获取描述数据失败，请检查网络连接。".localized())
                    }
                    return
                }
            }
        } else {
            setup_none(dep: "发生了未知错误。".localized())
        }
    }
    
}


extension LKPackageDetail: UIScrollViewDelegate {
    
    func updateColor() {
        self.banner_section.button.backgroundColor = self.theme_color
        self.view.backgroundColor = self.theme_color_bak
//        for item in section_headers {
//            item.update_color(color: theme_color)
//        }
        scrollViewDidScroll(contentView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentView == scrollView {
            // 基准线
            var base = CGFloat(233)
            base -= (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            base -= (self.navigationController?.navigationBar.frame.height ?? 0)
            base -= (self.navigationController?.navigationBar.frame.height ?? 0)
            base -= 20
            let offset = self.contentView.contentOffset
            // 基准线 - 当前线 超过部分变透明
            var calc = (offset.y - base) / 66
            if calc > 0.9 {
                calc = 1
            }
            let bannerc = self.theme_color_bak
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: bannerc.red,
                                                                               green: bannerc.green,
                                                                               blue: bannerc.blue,
                                                                               alpha: calc)
            self.status_bar_cover.backgroundColor = UIColor(red: bannerc.red,
                                                            green: bannerc.green,
                                                            blue: bannerc.blue,
                                                            alpha: calc)
            var text_color: UIColor
            if !self.tint_color_consit {
                text_color = theme_color.transit2white(percent: 1 - calc)
            } else {
                text_color = theme_color
            }
            self.navigationController?.navigationBar.tintColor = text_color
            calc = (offset.y - base - 98) / 60
            if calc > 1 {
                calc = 1
            }
            if !self.tint_color_consit {
                text_color = theme_color.transit2white(percent: 1 - calc)
            } else {
                text_color = theme_color
            }
            text_color = UIColor(red: Int(text_color.red), green: Int(text_color.green), blue: Int(text_color.blue), transparency: calc) ?? text_color
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: text_color]
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if contentView == scrollView {
            if scrollView.contentOffset.y > 48 && scrollView.contentOffset.y < 256 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.contentView.contentOffset.y = 233 -
                        (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) -
                        (self.navigationController?.navigationBar.frame.height ?? 0)
                }, completion: { (_) in
                })
            }
        }
    }
}

// 死了哦

extension LKPackageDetail {
    
    func doJsonSetupLevelRoot(json: [String : Any]) {
        var nextLevelSetup: [[String : Any]]?
        for item in json {
            switch item.key {
            case "headerImage":
                self.banner_image.sd_setImage(with: URL(string: (item.value as? String) ?? "")) { (img, _, _, _) in
                    if img != nil {
                        self.img_initd = true
                        let color = img!.getColors()?.background ?? .white
                        self.banner_image.backgroundColor = color
                        if color.red + color.blue + color.green > 2.6 {
                            self.tint_color_consit = true
                        }
                    }
                    self.updateColor()
                }
            case "minVersion":
                _ = "谁他妈在乎您嘞".localized()
            case "tintColor":
                if let color = UIColor(hexString: (item.value as? String) ?? "") {
                    self.theme_color = color
                }
                updateColor()
            case "backgroundColor":
                if let color = UIColor(hexString: (item.value as? String) ?? "") {
                    self.theme_color_bak = color
                }
                updateColor()
            case "tabs":
                nextLevelSetup = item.value as? [[String : Any]]
            case "class":
                if (item.value as? String) != "DepictionTabView" {
                    print("[?] 有意思咯 " + ((item.value as? String) ?? ""))
                }
            default:
                print("[*] 丢弃数据： " + item.key)
            }
            if nextLevelSetup != nil {
                doJsonSetUpLevelTabs(tabs: nextLevelSetup!)
            }
        }
    }
    
    func doJsonSetUpLevelTabs(tabs: [[String: Any]]) {
        
        
        
        for tab in tabs {
            
            
//            for view in tab {
//                switch view.key {
//
//
//
//                default:
//                    print("[*] 丢弃数据： " + view.key)
//                }
//            }
        }
        
        updateColor()
        
    }
    
}
