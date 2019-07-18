//
//  LKPackageDetail.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/17.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import WebKit

class LKPackageDetail: UIViewController {
    
    public var item: DBMPackage = DBMPackage()
    private var name = ""
    private var theme_color = UIColor()
    private var contentView = UIScrollView()
    
    let status_bar_cover = UIView()
    let banner_image = UIImageView()
    let banner_section = common_views.LKIconBannerView()
    
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
        
        // 更新一次名字
        if let namer = item.version.first!.value.first!.value["NAME"] {
            name = namer
            title = name
        }
        
        // --------------------- 开始处理你的脸！
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        theme_color = LKRoot.ins_color_manager.read_a_color("main_title_two")
        
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
        status_bar_cover.alpha = 0
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
            if img != nil && self.banner_image.image == nil {
                self.banner_image.image = img?.blur(offset: 66)
                if LKRoot.settings?.use_dark_mode ?? false {
                    self.theme_color = img!.areaAverage().lighten(by: 0.5)
                } else {
                    self.theme_color = img!.areaAverage().darken(by: 0.5)
                }
                var base = CGFloat(233)
                base -= (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
                base -= (self.navigationController?.navigationBar.frame.height ?? 0)
                base -= (self.navigationController?.navigationBar.frame.height ?? 0)
                base -= 20
                let offset = self.contentView.contentOffset
                // 基准线 - 当前线 超过部分变透明
                var calc = (offset.y - base) / 66
                if calc > 1 {
                    calc = 1
                }
                self.status_bar_cover.alpha = calc
                self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: calc)
                let text_color = LKRoot.ins_color_manager.read_a_color("main_title_two").transit2white(percent: 1 - calc)
                self.navigationController?.navigationBar.tintColor = text_color
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: text_color]
            }
        }
        
        contentView.addSubview(banner_section)
        banner_section.snp.makeConstraints { (x) in
            x.top.equalTo(banner_image.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(123)
        }
        
        
        // 防止抽风
        DispatchQueue.main.async {
            var base = CGFloat(233)
            base -= (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            base -= (self.navigationController?.navigationBar.frame.height ?? 0)
            base -= (self.navigationController?.navigationBar.frame.height ?? 0)
            base -= 20
            let offset = self.contentView.contentOffset
            // 基准线 - 当前线 超过部分变透明
            var calc = (offset.y - base) / 66
            if calc > 1 {
                calc = 1
            }
            self.status_bar_cover.alpha = calc
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: calc)
            let text_color = LKRoot.ins_color_manager.read_a_color("main_title_two").transit2white(percent: 1 - calc)
            self.navigationController?.navigationBar.tintColor = text_color
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: text_color]
        }
        
    }
    
    
}


extension LKPackageDetail: UIScrollViewDelegate {
    
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
            if calc > 1 {
                calc = 1
            }
            self.status_bar_cover.alpha = calc
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: calc)
            let text_color = theme_color.transit2white(percent: 1 - calc)
            self.navigationController?.navigationBar.tintColor = text_color
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
