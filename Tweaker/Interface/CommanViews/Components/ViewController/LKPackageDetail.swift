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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
//        (Tweaker.DBMPackage) self.item = 0x0000600002af9f80 {
//            id = "com.lakr233.SailyTest"
//            latest_update_time = "2019.07.17 11:30:57"
//            one_of_the_package_name_lol = "SailyTest"
//            version = 1 key/value pair {
//                [0] = {
//                    key = "0.0.9"
//                    value = 1 key/value pair {
//                        [0] = {
//                            key = "http://qaq.loc/repo/"
//                            value = 18 key/value pairs {
//                                [0] = (key = "ARCHITECTURE", value = "iphoneos-arm")
//                                [1] = (key = "CONFLICTS", value = "com.lakr233.jw.SailyPackageManager")
//                                [2] = (key = "PACKAGE", value = "com.lakr233.SailyTest")
//                                [3] = (key = "MAINTAINER", value = "https://twitter.com/Lakr233")
//                                [4] = (key = "PRIORITY", value = "nil")
//                                [5] = (key = "DESCRIPTION", value = "Saily Package Manager Test Package")
//                                [6] = (key = "ICON", value = "http://qaq.loc/repos/CydiaIcon.png")
//                                [7] = (key = "DEPICTION", value = "https://github.com/Co2333/SailyPackageManager")
//                                [8] = (key = "_internal_SIG_begin_update", value = "0x1")
//                                [9] = (key = "SECTION", value = "SystemD")
//                                [10] = (key = "AUTHOR", value = "Lakr Aream")
//                                [11] = (key = "ESSENTIAL", value = "NO")
//                                [12] = (key = "DEPENDS", value = "firmware (>= 5.0)")
//                                [13] = (key = "VERSION", value = "0.0.9")
//                                [14] = (key = "DEV", value = "Lakr Aream")
//                                [15] = (key = "REPLACES", value = "com.lakr233.jw.SailyStartupDaemon")
//                                [16] = (key = "HOMEPAGE", value = "https://twitter.com/Lakr233")
//                                [17] = (key = "NAME", value = "SailyTest")
//                            }
//                        }
//                    }
//                }
//            }
//            signal = ""
//        }
        
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
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
        
    }
    
    
}
