//
//  AppRootClass.swift
//  Tweaker
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
    
    public var root_path: String?
    public var root_db: Database?
    
    public let queue_operation                                  = OperationQueue()
    public let queue_operation_single_thread                    = OperationQueue()
    public let queue_dispatch                                   = DispatchQueue(label: "com.lakr233.common.queue", qos: .utility, attributes: .concurrent)
    public let queue_alamofire                                  = DispatchQueue(label: "com.lakr233.alamofire.queue", qos: .utility, attributes: .concurrent)
    
    var container_cache_uiview = [UIView]()                 // 视图缓存咯
    var container_news_repo    = [DMNewsRepo]()             // 新闻源缓存
    
    let ins_color_manager = color_sheet()                   // 颜色表 - 以后拿来写主题
    let ins_view_manager = common_views()                   // 视图扩展
    let ins_user_manager = app_user_class()                 // 用户管理
    let ins_common_operator = app_opeerator()               // 通用处理
    
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
        try? FileManager.default.removeItem(atPath: root_path! + "/Lakr233.db-wal")
        try? FileManager.default.createDirectory(atPath: root_path! + "/daemon.call", withIntermediateDirectories: true, attributes: nil)
        root_db = Database(withPath: root_path! + "/" + "Lakr233.db")
        try? FileManager.default.removeItem(atPath: root_path! + "/caches")
        
        // 检查数据库数据完整性
        try? root_db?.create(table: "LKNewsRepos", of: DBMNewsRepo.self)
        try? root_db?.create(table: "LKSettings", of: DBMSettings.self)
        let read_try: [DBMSettings]? = try? root_db?.getObjects(fromTable: "LKSettings")
        if read_try == nil || read_try?.count == 0 {
            // 开始初始化数据库
            let new_setting = DBMSettings()
            // 伪造UDID
            let fake_udid = UUID().uuidString
            var fake_udid_out = ""
            for item in fake_udid where item != "-" {
                fake_udid_out += item.description
            }
            fake_udid_out += UUID().uuidString.dropLast(28)
            fake_udid_out = fake_udid_out.lowercased()
            new_setting.fake_UDID = fake_udid_out
            try? root_db?.insert(objects: [new_setting], intoTable: "LKSettings")
            // 写入新闻源地址
            let default_news_repos = DBMNewsRepo()
            default_news_repos.link = "https://lakraream.github.io/Tweaker/"
            default_news_repos.sort_id = 0
            try? root_db?.insert(objects: [default_news_repos], intoTable: "LKNewsRepos")
        }
        
        
        
        // 发送到下载处理引擎
        
    }
}


