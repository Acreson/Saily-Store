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
    private var contentView = UIScrollView()
    
    let banner_image = UIImageView()
    
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
//            title = name
        }
        
        // --------------------- 开始处理你的脸！
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        view.addSubview(contentView)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
        contentView.contentSize = CGSize(width: 0, height: 1888)
        
        contentView.addSubview(banner_image)
        banner_image.contentMode = .scaleAspectFill
        banner_image.snp.makeConstraints { (x) in
            if LKRoot.safe_area_needed {
                x.top.lessThanOrEqualTo(self.contentView.snp.top).offset(-88)
                x.top.lessThanOrEqualTo(self.view.snp.top).offset(0)
                x.height.equalTo(233)
            } else {
                x.top.lessThanOrEqualTo(self.contentView.snp.top).offset(0)
                x.top.lessThanOrEqualTo(self.view.snp.top).offset(0)
                x.height.equalTo(166)
            }
            x.left.equalTo(view.snp.left)
            x.right.equalTo(view.snp.right)
        }
        
        if LKRoot.settings?.use_dark_mode ?? false {
            banner_image.image = UIImage(named: "s.darkblue")
        } else {
            banner_image.image = UIImage(named: "BGBlue")
        }
        banner_image.clipsToBounds = true
        
        // image 和 navigation bar 的透明操作
        let label = UILabel(text: "Hi")
        contentView.addSubview(label)
        label.textAlignment = .center
        label.snp.makeConstraints { (x) in
            if LKRoot.safe_area_needed {
                x.top.equalTo(self.contentView.snp.top).offset(-88 + 233 + 28)
            } else {
                x.top.lessThanOrEqualTo(self.view.snp.top).offset(0 + 166 + 28)
            }
            x.left.equalTo(view.snp.left)
            x.right.equalTo(view.snp.right)
        }
        
    }
    
    
}
