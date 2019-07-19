//
//  LKPackageDetail.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/17.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import WebKit
import AVFoundation
import SwiftyMarkdown
import JJFloatingActionButton

// swiftlint:disable:next type_body_length
class LKPackageDetail: UIViewController {
    
    public var item: DBMPackage = DBMPackage()
    private var theme_color = UIColor()
    private var theme_color_bak = UIColor()
    private var tint_color_consit = false
    private var contentView = UIScrollView()

    private var sum_content_height = 0
    
    var webView: WKWebView = WKWebView()
    
    let status_bar_cover = UIView()
    let banner_image = UIImageView()
    let banner_section = common_views.LKIconBannerView()
//    let section_headers = [common_views.LKSectionBeginHeader]()
    
    var buttonActionStore = [String]()
    
    var currentAnchor = UIView()
    
    var img_initd = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        updateColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationController?.navigationBar.tintColor = LKRoot.ins_color_manager.read_a_color("main_tint_color")
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: LKRoot.ins_color_manager.read_a_color("main_tint_color")]
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            let red = self.theme_color.redRead()
            let green = self.theme_color.greenRead()
            let blue = self.theme_color.blueRead()
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: red,
                                                                               green: green,
                                                                               blue: blue,
                                                                               alpha: 1)
        }, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)

        
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
        sum_content_height += 233
        
        banner_image.clipsToBounds = true
        // 获取图标
        let d1 = UIImageView()
        let icon_addr = item.version.first?.value.first?.value["ICON"] ?? ""
        d1.sd_setImage(with: URL(string: icon_addr)) { (img, _, _, _) in
            if img != nil && !self.img_initd {
                let color = img!.getColors()?.background ?? .white
                self.banner_image.backgroundColor = color
                let red = color.redRead()
                let blue = color.blueRead()
                let green = color.greenRead()
                if red + blue + green > 2.6 {
                    self.tint_color_consit = true
                }
            } else {
                let color = UIImage(named: TWEAK_DEFAULT_IMG_NAME)?.getColors()?.background ?? .white
                self.banner_image.backgroundColor = color
                let red = color.redRead()
                let blue = color.blueRead()
                let green = color.greenRead()
                if red + blue + green > 2.6 {
                    self.tint_color_consit = true
                }
            }
            self.updateColor()
        }
        
        contentView.addSubview(banner_section)
        banner_section.snp.makeConstraints { (x) in
            x.top.equalTo(contentView.snp.top).offset(233)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(98)
        }
        sum_content_height += 98
        banner_section.icon.sd_setImage(with: URL(string: icon_addr), placeholderImage: UIImage(named: TWEAK_DEFAULT_IMG_NAME))
        banner_section.title.text = LKRoot.ins_common_operator.PAK_read_name(version: item.version.first?.value ?? LKRoot.ins_common_operator.PAK_return_error_vision())
        title = banner_section.title.text
        banner_section.sub_title.text = LKRoot.ins_common_operator.PAK_read_auth(version: item.version.first?.value ?? LKRoot.ins_common_operator.PAK_return_error_vision()).0
        banner_section.button.setTitle("操作".localized(), for: .normal)
        banner_section.button.backgroundColor = theme_color
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
            setup_Cydia(dep: dep ?? "")
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
        text.isScrollEnabled = false
        text.isUserInteractionEnabled = false
        contentView.addSubview(text)
        text.snp.makeConstraints { (x) in
            x.top.equalTo(self.banner_section.snp.bottom).offset(38)
            x.left.equalTo(self.view.snp.left).offset(18)
            x.right.equalTo(self.view.snp.right).offset(-18)
            x.height.equalTo(666)
        }
        let text2 = UITextView()
        text2.backgroundColor = .clear
        text2.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        text2.font = .boldSystemFont(ofSize: 10)
        text2.isScrollEnabled = false
        text2.isUserInteractionEnabled = false
        var read = "因出现未知错误现提供软件包的原始信息：\n\n".localized()
        let depsss = item.version.first?.value.first?.value ?? ["未知错误".localized() : "无更多信息".localized()]
        for item in depsss.keys.sorted() where !item.contains("_internal") {
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
            x.left.equalTo(self.view.snp.left).offset(18)
            x.right.equalTo(self.view.snp.right).offset(-18)
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
    
    var loadUrl = URL(string: "https://www.apple.com/")!
    func setup_Cydia(dep: String) {
        // 获取数据
        if let url = URL(string: dep) {
            IHProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                IHProgressHUD.dismiss()
            }
            contentView.addSubview(webView)
            webView.snp.makeConstraints { (x) in
                x.top.equalTo(self.currentAnchor.snp.bottom)
                x.left.equalTo(self.view.snp.left)
                x.right.equalTo(self.view.snp.right)
                x.height.equalTo(666)
            }
            webView.navigationDelegate = self
            webView.scrollView.isScrollEnabled = false
            loadWebPage(url: url)
            webView.allowsBackForwardNavigationGestures = false
        } else {
            setup_none(dep: "发生了未知错误。".localized())
        }
    }
    
    func loadWebPage(url: URL)  {
        webView.load(LKRoot.ins_networking.read_request(url: url))
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
                            self.doJsonSetupLevelRoot(json: json, origStr: read)
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
            let red = bannerc.redRead()
            let green = bannerc.greenRead()
            let blue = bannerc.blueRead()
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: red,
                                                                               green: blue,
                                                                               blue: blue,
                                                                               alpha: calc)
            self.status_bar_cover.backgroundColor = UIColor(red: red,
                                                            green: green,
                                                            blue: blue,
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
            text_color = UIColor(red: Int(text_color.redRead()), green: Int(text_color.greenRead()), blue: Int(text_color.blueRead()), transparency: calc) ?? text_color
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
    
    func doJsonSetupLevelRoot(json: [String : Any], origStr: String) {
        if let img_addr = json["headerImage"] as? String {
            self.banner_image.sd_setImage(with: URL(string: img_addr)) { (img, _, _, _) in
                if img != nil {
                    self.img_initd = true
                    let color = img!.getColors()?.background ?? .white
                    self.banner_image.backgroundColor = color
                    let red = color.redRead()
                    let blue = color.blueRead()
                    let green = color.blueRead()
                    if red + blue + green > 2.6 {
                        self.tint_color_consit = true
                    }
                }
            }
        }
        
        if let tint_color = json["tintColor"] as? String {
            if let color = UIColor(hexString: tint_color) {
                self.theme_color = color
            }
        }
        
        if let back_color = json["backgroundColor"] as? String {
            if let color = UIColor(hexString: back_color) {
                self.theme_color_bak = color
            }
        }
        
        if let tabs = json["tabs"] as? [[String : Any]] {
            doJsonSetUpLevelTabs(tabs: tabs, origStr: origStr)
        }
    
    }
    
    func doJsonSetUpLevelTabs(tabs: [[String: Any]], origStr: String) {
        
        // tab 好像不需要排序

        for tab in tabs {
            var index = 0
            
            index += 1
            let header = common_views.LKSectionBeginHeader()
            if let someString = tab["tintColor"] as? String {
                header.theme_color = UIColor(hexString: someString)
            } else {
                header.theme_color = theme_color
            }
            if let someString = tab["tabname"] as? String {
                if someString != "" {
                    header.apart_init(section_name: someString)
                } else {
                    let read = "标签页 ".localized() + String(index)
                    header.apart_init(section_name: read)
                }
            } else {
                let read = "标签页 ".localized() + String(index)
                header.apart_init(section_name: read)
            }
            contentView.addSubview(header)
            header.snp.makeConstraints { (x) in
                x.top.equalTo(self.currentAnchor.snp.bottom)
                x.height.equalTo(50)
                x.left.equalTo(self.view.snp.left)
                x.right.equalTo(self.view.snp.right)
            }
            currentAnchor = header
            using_bottom_margins(height: 4)
            sum_content_height += 37
            
            for view in tab["views"] as? [[String : Any]] ?? [] {
                // (lldb) po ((tab["views"] as! [[String : Any]]))[0]
                // view 的类型是 [String : Any]
                if let class_name = view["class"] as? String {
                    switch class_name {
                    case "DepictionHeaderView": setup_HeaderView(object: view)
                    case "DepictionSubheaderView": setup_SubheaderView(object: view)
                    case "DepictionLabelView": setup_LabelView(object: view)
                    case "DepictionMarkdownView": setup_MarkdownView(object: view)
                    case "DepictionVideoView": setup_VideoView(object: view)
                    case "DepictionImageView": setup_ImageView(object: view)
                    case "DepictionScreenshotsView": setup_ScreenshotsView(object: view)
                    case "DepictionTableTextView": setup_TableTextView(object: view)
                    case "DepictionTableButtonView": setup_TableButtonView(object: view)
                    case "DepictionButtonView": setup_ButtonView(object: view)
                    case "DepictionSeparatorView": setup_SeparatorView(object: view)
                    case "DepictionSpacerView": setup_SpacerView(object: view)
                    case "DepictionAdmobView": setup_AdmobView(object: view)
                    case "DepictionRatingView": setup_RatingView(object: view)
                    case "DepictionReviewView": setup_ReviewView(object: view)
                    default: print("[?] 这嘛子玩意嘛： " + class_name)
                    }
                } else {
                    print("[?] 这个 view 没有 class ？")
                }
            }
        } // for tab in tabs {
        updateColor()
        
        using_bottom_margins()
        sum_content_height += 16
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.233) {
            self.contentView.contentSize.height = CGFloat(self.sum_content_height)
        }
        
        
    }
    
    func using_bottom_margins(height: Int = 16) {
        let d = UIView()
        contentView.addSubview(d)
        d.snp.makeConstraints { (x) in
            x.centerX.equalTo(self.view.snp.centerX)
            x.width.equalTo(0)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.height.equalTo(height)
        }
        self.currentAnchor = d
        sum_content_height += height
    }
    
    func setup_HeaderView(object: [String : Any]) {
        let subHeader = UILabel(text: object["title"] as? String ?? "")
        subHeader.font = .boldSystemFont(ofSize: 20)
        subHeader.textColor = self.theme_color
        subHeader.numberOfLines = 2
        if let alig_t = object["alignment"] as? Int {
            if alig_t == 1 {
                subHeader.textAlignment = .center
            } else if alig_t == 2 {
                subHeader.textAlignment = .right
            }
        }
        contentView.addSubview(subHeader)
        subHeader.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(18)
            x.right.equalTo(self.view.snp.right).offset(-18)
            x.top.equalTo(self.currentAnchor.snp.bottom).offset(4)
            x.height.equalTo(40)
        }
        if object["useMargins"] as? Bool ?? true {
            currentAnchor = subHeader
            sum_content_height += 44
        }
        if object["useBottomMargin"] as? Bool ?? true {
            using_bottom_margins(height: 8)
            sum_content_height += 8
        }
    }
    
    func setup_SubheaderView(object: [String : Any]) {
        let subHeader = UILabel(text: object["title"] as? String ?? "")
        subHeader.font = .boldSystemFont(ofSize: 14)
        subHeader.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
        subHeader.numberOfLines = 2
        contentView.addSubview(subHeader)
        subHeader.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(18)
            x.right.equalTo(self.view.snp.right).offset(-18)
            x.top.equalTo(self.currentAnchor.snp.bottom).offset(4)
            x.height.equalTo(25)
        }
        if object["useMargins"] as? Bool ?? true {
            currentAnchor = subHeader
            sum_content_height += 25
        }
        if object["useBottomMargin"] as? Bool ?? true {
            using_bottom_margins()
            sum_content_height += 16
        }
    }
    
    func setup_LabelView(object: [String : Any]) {
        
    }
    
    func setup_MarkdownView(object: [String : Any]) {
        
        guard let text = object["markdown"] as? String else {
            return
        }
        
        let markdown = UITextView()
        markdown.backgroundColor = .clear
        markdown.font = .boldSystemFont(ofSize: 14)
        if object["useRawFormat"] as? Bool ?? false || (text.contains("<") && text.contains("</")) || text.contains("<br") {
            markdown.attributedText = text.htmlToAttributedString
        } else {
            let atr_text = SwiftyMarkdown(string: text).attributedString().mutableCopy() as? NSMutableAttributedString
            atr_text?.setFontFace(font: .boldSystemFont(ofSize: 14))
            markdown.attributedText = atr_text
        }
        markdown.isEditable = false
        markdown.isScrollEnabled = false
        markdown.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        contentView.addSubview(markdown)
        markdown.snp.makeConstraints { (x) in
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
        }
        let currentAnchorSnapshot = self.currentAnchor
        DispatchQueue.main.async {
            let h = markdown.sizeThatFits(CGSize(width: self.view.frame.width - 28, height: .infinity))
            markdown.snp.remakeConstraints { (x) in
                x.top.equalTo(currentAnchorSnapshot.snp.bottom)
                x.left.equalTo(self.view.snp.left).offset(14)
                x.right.equalTo(self.view.snp.right).offset(-14)
                x.height.equalTo(h)
            }
            if object["useMargins"] as? Bool ?? true {
                self.sum_content_height += Int(h.height)
            }
        }
        
        if object["useMargins"] as? Bool ?? true {
            currentAnchor = markdown
        }
        
    }
    
    func setup_VideoView(object: [String : Any]) {
        
    }
    
    func setup_ImageView(object: [String : Any]) {
        
        guard let width = object["width"] as? Double else {
            return
        }
        
        guard let height = object["height"] as? Double else {
            return
        }
        
        guard let url_str = object["URL"] as? String else {
            return
        }
        
        guard let url = URL(string: url_str) else {
            return
        }
        
        guard let radius = object["cornerRadius"] as? Double else {
            return
        }
        
        let horizPadding = object["horizontalPadding"] as? Double
        
        if let somePadding = horizPadding {
            using_bottom_margins(height: Int(somePadding))
            sum_content_height += Int(somePadding)
        }
        
        let image = UIImageView()
        contentView.addSubview(image)
        image.snp.makeConstraints { (x) in
            x.centerX.equalTo(self.view.center)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.width.equalTo(width)
            x.height.equalTo(height)
        }
        sum_content_height += Int(height)
        image.sd_setImage(with: url, completed: nil)
        image.setRadiusCGF(radius: CGFloat(radius))
        currentAnchor = image
        
        if let somePadding = horizPadding {
            using_bottom_margins(height: Int(somePadding))
            sum_content_height += Int(somePadding)
        }
        
        if let somePadding = horizPadding {
            using_bottom_margins(height: Int(somePadding))
        }
    }
    
    func setup_ScreenshotsView(object: [String : Any]) {
        
        var object = object
        
        guard var screenshotsObjects = object["screenshots"] as? [[String : Any]] else {
            return
        }
        
        if object["ipad"] != nil && LKRoot.is_iPad {
            object = object["ipad"] as? [String : Any] ?? ["" : ""]
            guard let screenshotsObjects2 = object["screenshots"] as? [[String : Any]] else {
                return
            }
            screenshotsObjects = screenshotsObjects2
        }
        
        guard let itemSizeStr = object["itemSize"] as? String else {
            return
        }
//        I was stupid that.
//        let i1 = itemSizeStr.dropFirst().split(separator: ",").first?.to_String().drop_space() ?? "0"
//        let i2 = itemSizeStr.dropLast().split(separator: ",").last?.to_String().drop_space() ?? "0"
//        let itemSize = CGSize(width: Double(i1) ?? 0, height: Double(i2) ?? 0)
//        if itemSize.width <= 0 || itemSize.height <= 0 {
//            return
//        }
        let itemSize = NSCoder.cgSize(for: itemSizeStr)
        if itemSize.width <= 0 || itemSize.height <= 0 {
            return
        }
        guard let radius = object["itemCornerRadius"] as? Int else {
            return
        }
        
        // 开始创建stacks
        let container = UIScrollView()
        let placeholder = UIView()
        contentView.addSubview(placeholder)
        contentView.addSubview(container)
        container.showsVerticalScrollIndicator = false
        container.showsHorizontalScrollIndicator = false
        container.isUserInteractionEnabled = true
        container.decelerationRate = .fast
        container.contentSize = CGSize(width: screenshotsObjects.count * (Int(itemSize.width) + 18) + 18, height: 0)
        placeholder.snp.makeConstraints { (x) in
            x.centerX.equalTo(self.view.snp.centerX)
            x.width.equalTo(0)
            x.top.equalTo(self.currentAnchor.snp.bottom).offset(8)
            x.height.equalTo(itemSize.height + 8)
        }
        sum_content_height += Int(itemSize.height) + 16
        currentAnchor = placeholder
        container.snp.makeConstraints { (x) in
            x.top.equalTo(placeholder.snp.top)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(itemSize.height)
        }
        
        var screenshotAnchor = UIView()
        container.addSubview(screenshotAnchor)
        screenshotAnchor.snp.makeConstraints { (x) in
            x.width.equalTo(0)
            x.top.equalTo(container.snp.top)
            x.height.equalTo(itemSize.height)
            x.left.equalTo(container.snp.left)
        }
        
        for screenshotObject in screenshotsObjects {
            if screenshotObject["video"] as? Bool ?? false {
                let plh = UIView()
                plh.clipsToBounds = true
                plh.setRadiusINT(radius: radius)
                plh.backgroundColor = .gray
                container.addSubview(plh)
                plh.snp.makeConstraints { (x) in
                    x.left.equalTo(screenshotAnchor.snp.right).offset(18)
                    x.top.equalTo(screenshotAnchor.snp.top)
                    x.width.equalTo(itemSize.width)
                    x.height.equalTo(itemSize.height)
                }
                screenshotAnchor = plh
                let url = URL(string: screenshotObject["url"] as? String ?? "") ?? URL(string: "https://somethingwentwrong.com.for.sure")!
                let player = AVPlayer(url: url)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = .resizeAspectFill
                DispatchQueue.main.async {
                    playerLayer.frame = plh.frame
                }
                playerLayer.frame = self.view.bounds
                plh.layer.addSublayer(playerLayer)
                player.volume = 0
                player.actionAtItemEnd = .none
                player.play()
                NotificationCenter.default.addObserver(self, selector: #selector(videoEndNotify(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            } else {
                let img = UIImageView()
                container.addSubview(img)
                img.contentMode = .scaleAspectFill
                img.clipsToBounds = true
                img.backgroundColor = .gray
                img.setRadiusINT(radius: radius)
                img.sd_setImage(with: URL(string: screenshotObject["url"] as? String ?? ""), completed: nil)
                img.isUserInteractionEnabled = false
                img.snp.makeConstraints { (x) in
                    x.left.equalTo(screenshotAnchor.snp.right).offset(18)
                    x.top.equalTo(screenshotAnchor.snp.top)
                    x.width.equalTo(itemSize.width)
                    x.height.equalTo(itemSize.height)
                }
                screenshotAnchor = img
            }
        }
        
    }
    
    func setup_TableTextView(object: [String : Any]) {
        guard let s1 = object["title"] as? String else {
            return
        }
        guard let s2 = object["text"] as? String else {
            return
        }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "oops??")
        cell.textLabel?.text = s1
        cell.detailTextLabel?.text = s2
        cell.textLabel?.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        cell.detailTextLabel?.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
        contentView.addSubview(cell)
        cell.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(3)
            x.right.equalTo(self.view.snp.right).offset(-3)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.height.equalTo(44)
        }
        self.currentAnchor = cell
        sum_content_height += 44
    }
    
    func setup_TableButtonView(object: [String : Any]) {
        guard let title = object["title"] as? String else {
            return
        }
        guard let action = object["action"] as? String else {
            return
        }
        self.buttonActionStore.append(action)
        if let backupAction = object["backupAction"] as? String {
            self.buttonActionStore.append(backupAction)
        } else {
            self.buttonActionStore.append(action)
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "oooooops?")
        let button = UIButton()
        contentView.addSubview(cell)
        contentView.addSubview(button)
        cell.textLabel?.text = title
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        cell.textLabel?.textColor = theme_color
        contentView.addSubview(cell)
        cell.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(3)
            x.right.equalTo(self.view.snp.right).offset(-3)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.height.equalTo(44)
        }
        button.titleLabel?.textAlignment = .left
        button.snp.makeConstraints { (x) in
            x.edges.equalTo(cell.snp.edges)
        }
        button.tag = buttonActionStore.count - 1
        button.addTarget(self, action: #selector(button_call(sender:)), for: .touchUpInside)
        self.currentAnchor = cell
        self.contentView.bringSubviewToFront(button)
        sum_content_height += 44
    }
    
    @objc func button_call(sender: UIButton) {
        
        let tag = sender.tag
        if tag - 1 < 0 || tag >= buttonActionStore.count {
            return
        }
        if let url1 = URL(string: buttonActionStore[tag - 1]) {
            if UIApplication.shared.canOpenURL(url1) {
                UIApplication.shared.open(url1, options: [:], completionHandler: nil)
            } else {
                if let url2 = URL(string: buttonActionStore[tag]) {
                    UIApplication.shared.open(url2, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    
    func setup_ButtonView(object: [String : Any]) {
        
    }
    
    func setup_SeparatorView(object: [String : Any]) {
        using_bottom_margins(height: 8)
        let sep = UIView()
        sep.backgroundColor = .gray
        sep.alpha = 0.233
        contentView.addSubview(sep)
        sep.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(18)
            x.right.equalTo(self.view.snp.right).offset(-18)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.height.equalTo(0.5)
        }
        sum_content_height += 1
        self.currentAnchor = sep
    }
    
    func setup_SpacerView(object: [String : Any]) {
        using_bottom_margins()
    }
    
    func setup_AdmobView(object: [String : Any]) {
        return
    }
    
    func setup_RatingView(object: [String : Any]) {
        
    }
    
    func setup_ReviewView(object: [String : Any]) {
        
    }
    
}

extension LKPackageDetail /* AVPlayer Section*/ {
    
    @objc func videoEndNotify(sender: Any) {
        if let noter = sender as? NSNotification {
            (noter.object as? AVPlayerItem)?.seek(to: .zero, completionHandler: nil)
        }
    }
    
}

extension LKPackageDetail: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = (navigationResponse.response as? HTTPURLResponse)?.url else {
            decisionHandler(.cancel)
            return
        }
        if url != loadUrl {
            loadUrl = url
            decisionHandler(.cancel)
            loadWebPage(url: url)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, _) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, _) in
                    self.webView.snp.remakeConstraints({ (x) in
                        x.top.equalTo(self.currentAnchor.snp.bottom)
                        x.left.equalTo(self.view.snp.left)
                        x.right.equalTo(self.view.snp.right)
                        x.height.equalTo(height as? CGFloat ?? 0)
                    })
                    self.contentView.contentSize.height = 233 + (height as? CGFloat ?? 0)
                })
            }
            
        })
    }
}
