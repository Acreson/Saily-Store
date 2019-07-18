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
        
        // 检查是否存在 Sileo 死了哦
        
        
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
        
    }
    
    
}


extension LKPackageDetail: UIScrollViewDelegate {
    
    func updateColor() {
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: text_color]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentView == scrollView {
            // 基准线
            var base = CGFloat(233)
            base -= (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            base -= (self.navigationController?.navigationBar.frame.height ?? 0)
            base -= (self.navigationController?.navigationBar.frame.height ?? 0)
            base -= 20
            let offset = scrollView.contentOffset
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
