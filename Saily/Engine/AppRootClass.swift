//
//  AppRootClass.swift
//  Saily
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

let LKRoot = app_root_class()

class app_root_class {
    
    #if DEBUG
    public let is_debug = true
    #else
    public let is_debug = false
    #endif
    
    // iOS 13 Fix
    var ever_went_background = false
    
    var is_iPad = false
    // swiftlint:disable:next discouraged_direct_init
    let shared_device = UIDevice()
    
    public var root_path: String?
    public var root_db: Database?
    
    public var settings: DBMSettings?
    public var safe_area_needed: Bool = false
    public var current_page = UIViewController()
    public var manager_reg = manage_view_reg()
    
    public let queue_operation                                  = OperationQueue()
    public let queue_operation_single_thread                    = OperationQueue()
    public let queue_dispatch                                   = DispatchQueue(label: "com.lakr233.common.queue", qos: .utility, attributes: .concurrent)
    public let queue_alamofire                                  = DispatchQueue(label: "com.lakr233.alamofire.queue", qos: .utility, attributes: .concurrent)
    
    // 缓存view好像没啥用
//    var container_cache_uiview = [UIView]()                               // 视图缓存咯
    var container_string_store              = [String : String]()           // ???
    var container_news_repo                 = [DMNewsRepo]()                // 新闻源缓存
    var container_news_repo_DBSync          = [DMNewsRepo]()                // 包含未刷新的源
    var container_package_repo              = [DMPackageRepos]()            // 软件源缓存
    var container_package_repo_DBSync       = [DMPackageRepos]()            // 包含未刷新的源
    var container_package_repo_download     = [String : String]()           // 软件源缓存
    var container_packages                  = [String : DBMPackage]()       // 软件包缓存
    var container_packages_DBSync           = [String : DBMPackage]()       // 软件包缓存
    var container_recent_update             = [DBMPackage]()                // 最近更新缓存
    var container_manage_cell_status        = [String : Bool]()             // 管理页面是否展开
    var container_packages_installed_DBSync = [String : DBMPackage]()       // 已安装软件包
    var container_recent_installed          = [DBMPackage]()                // 最近安装缓存
    var container_packages_randomfun_DBSync = [DBMPackage]()                // 已安装软件包
    
    let ins_color_manager = color_sheet()                   // 颜色表 - 以后拿来写主题
    let ins_view_manager = common_views()                   // 视图扩展
    let ins_networking = networking()                       // 网络处理
    let ins_user_manager = app_user_class()                 // 用户管理
    let ins_common_operator = app_opeerator()               // 通用处理
    
    //  接口
    var tabbar_view_controller: UITabBarController?
    
    // 初始化 App
    func initializing() {
        
        // 初始化变量
        queue_operation_single_thread.maxConcurrentOperationCount = 1
        
        // 初始化文件路径
        root_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if root_path!.contains("CoreSimulator") {
            print("[*] 从模拟器启动应用程序 - " + (root_path ?? "wtf?"))
        } else if root_path!.contains("/Containers/Data/Application") {
            print("[*] 从沙盒启动应用程序。")
        }
        try? FileManager.default.removeItem(atPath: root_path! + "/daemon.call")
//        try? FileManager.default.removeItem(atPath: root_path! + "/Lakr233.db-wal") 操这玩意害惨我了
        try? FileManager.default.createDirectory(atPath: root_path! + "/daemon.call", withIntermediateDirectories: true, attributes: nil)
        root_db = Database(withPath: root_path! + "/" + "Lakr233.db")
        try? FileManager.default.removeItem(atPath: root_path! + "/caches")
        
        // 检查数据库数据完整性
        let read_try: [DBMSettings]? = try? root_db?.getObjects(fromTable: common_data_handler.table_name.LKSettings.rawValue)
        if read_try == nil || read_try?.count != 1 {
            bootstrap_this_app()
        } else {
            settings = read_try?.first!
        }
        
        // 复制完整的 dpkg 记录信息
        let installed_update_session = UUID().uuidString
        LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE_SESSION"] = installed_update_session
        ins_common_operator.YA_build_installed_list(session: installed_update_session) { (ret) in
            if ret == operation_result.failed.rawValue {
                print("[E] 无法从 dpkg 获取安装的数据。")
            }
        }

        // 黑暗模式初始化
        ins_color_manager.reFit()
        
        // 启动时同步一次数据
        let package_from_database: [DBMPackage]? = try? LKRoot.root_db?.getObjects(fromTable: common_data_handler.table_name.LKPackages.rawValue)
        for item in package_from_database ?? [] {
            container_packages[item.id] = item
        }
        
        // 发送到下载处理引擎
        queue_dispatch.async {
            self.ins_common_operator.PR_sync_and_download(sync_all: true) { (_) in
            }
        }
    }
    
    func bootstrap_this_app() {
        // 开始初始化数据库
        try? root_db?.create(table: common_data_handler.table_name.LKNewsRepos.rawValue, of: DBMNewsRepo.self)
        try? root_db?.create(table: common_data_handler.table_name.LKSettings.rawValue, of: DBMSettings.self)
        try? root_db?.create(table: common_data_handler.table_name.LKPackageRepos.rawValue, of: DBMPackageRepos.self)
        try? root_db?.create(table: common_data_handler.table_name.LKPackages.rawValue, of: DBMPackage.self)
        try? root_db?.create(table: common_data_handler.table_name.LKRecentInstalled.rawValue, of: DBMPackage.self)
        let new_setting = DBMSettings()
        new_setting.card_radius = 8
        // 伪造UDID
        let fake_udid = UUID().uuidString
        var fake_udid_out = ""
        for item in fake_udid where item != "-" {
            fake_udid_out += item.description
        }
        fake_udid_out += UUID().uuidString.dropLast(28)
        fake_udid_out = fake_udid_out.lowercased()
        new_setting.fake_UDID = fake_udid_out
        new_setting.network_timeout = 16
        settings = new_setting
        try? root_db?.insert(objects: [new_setting], intoTable: common_data_handler.table_name.LKSettings.rawValue)
        // 写入新闻源地址
        let default_news_repos_saily = DBMNewsRepo()
        default_news_repos_saily.link = "https://lakraream.github.io/Saily/"
        default_news_repos_saily.sort_id = 0
        let default_news_repos_aream = DBMNewsRepo()
        default_news_repos_aream.link = "https://lakraream.github.io/AreamN/"
        default_news_repos_aream.sort_id = 1
        try? root_db?.insert(objects: [default_news_repos_saily, default_news_repos_aream], intoTable: common_data_handler.table_name.LKNewsRepos.rawValue)
//        #if DEBUG                                                                                       // 压力测试源
//        let default_links =  [
//            "http://qaq.loc/repos/",
//            "https://apt.bingner.com/",
//            "http://build.frida.re/",
//            "https://repo.chariz.io/",
//            "https://sparkdev.me/",
//            "https://repo.nepeta.me/",
//            "https://cydia.akemi.ai/",
//            "http://apt.keevi.cc/",
//            "https://repo.chimera.sh/",
//            "https://apt.uozi.org/",
//            "https://apt.wxhbts.com/",
//            "https://apt.cydiakk.com/",
//            "http://apt.hackcn.net/",
//            "http://repounclutter.coolstar.org/",
//            "https://cydia.kiiimo.org/",
//            "https://apt.abcydia.com/",
//            "http://julioverne.github.io/",
//            "http://jakeashacks.ga/cydia/",
//            "http://www.alonemonkey.com/cydiarepo/",
//            "https://repo.dynastic.co/"
//        ]
//        #else
        let default_links = [
            "https://apt.bingner.com/",
            "https://repo.chariz.io/",
            "https://repo.nepeta.me/",
            "https://repo.dynastic.co/"
        ]
//        #endif
//                             "http://repo.packix.com/"] Always error when debugging.
        var insert = [DBMPackageRepos]()
        var index = 0
        for item in default_links {
            let obj = DBMPackageRepos()
            obj.link = item
            obj.sort_id = index
            index += 1
            insert.append(obj)
        }
        try? root_db?.insert(objects: insert, intoTable: common_data_handler.table_name.LKPackageRepos.rawValue)
    }
    
}


