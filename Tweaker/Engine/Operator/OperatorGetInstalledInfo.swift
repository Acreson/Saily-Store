//
//  OperatorGetInstalledInfo.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension app_opeerator {
    
    // YA means 已安装 Yi An Zhuang
    // Because when I tried to use AI or II or sth like that,
    // It always like fucked by ilIL1
    // Thanks for understanding
    
    func YA_sync_dpkg_info() {
        try? FileManager.default.removeItem(atPath: LKRoot.root_path! + "/dpkg")
        try? FileManager.default.copyItem(atPath: "/Library/dpkg", toPath: LKRoot.root_path! + "/dpkg")
        try? FileManager.default.copyItem(atPath: "/Library/dpkg/status", toPath: LKRoot.root_path! + "/dpkg/status")
    }
    
    func YA_build_installed_list(session: String, _ CallB: @escaping (Int) -> Void) {
        YA_sync_dpkg_info()
        // 尝试从存档获取
        // 如果失败那尝试从原始文件获取
        var read_status = (try? String(contentsOfFile:  LKRoot.root_path! + "/dpkg/status")) ?? "ERR_READ"
        if read_status == "ERR_READ" {
            read_status = (try? String(contentsOfFile:  "/Library/dpkg/status")) ?? "ERR_READ"
        }
        if read_status == "ERR_READ" {
            CallB(operation_result.failed.rawValue)
            return
        }
        
        LKRoot.container_string_store["STR_SIG_PROGRESS"] = "正在刷新软件包列表，这可能需要一些时间。".localized()
        if LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE"] == "TRUE" || session != LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE_SESSION"] {
            return
        }
        LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE"] = "TRUE"
        
        print("[*] 开始更新已安装")
        
        var package = [String : DBMPackage]()
        let read_db: [DBMPackage]? = try? LKRoot.root_db?.getObjects(fromTable: common_data_handler.table_name.LKRecentInstalled.rawValue)
        for item in read_db ?? [] {
            package[item.id] = item
            item.version.removeAll()
        }
        
        // 获取时间
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let now = formatter.string(from: date)
        
        let update_sig = DBMPackage()
        update_sig.signal = "BEGIN_UPDATE"
        try? LKRoot.root_db?.update(table: common_data_handler.table_name.LKRecentInstalled.rawValue,
                                    on: [DBMPackage.Properties.signal],
                                    with: update_sig)
        
        
        var read_in = read_status.cleanRN()
        read_in.append("\n\n")
        // 进行解包
        do {
            // 临时结构体
            var info_head = ""
            var info_body = ""
            var in_head = true
            var line_break = false
            var has_a_maohao = false
            var this_package = [String : String]()
            // 开始遍历数据
            for char in read_in {
                let c = char.description
                inner: if c == ":" {
                    line_break = false
                    in_head = false
                    if has_a_maohao {
                        info_body += ":"
                    } else {
                        has_a_maohao = true
                    }
                } else if c == "\n" {
                    if line_break == true {
                        // 两行空行，新数据包 判断软件包是否存在 如果存在则更新version字段
                        if this_package["PACKAGE"] == nil || this_package["VERSION"] == nil {
                            //                            print("[*] 丢弃没有id的软件包")
                        } else if package[this_package["PACKAGE"]!] != nil {
                            // 存在软件包
                            // 直接添加 version 不检查 version 是否存在因为它不存在就奇怪了
                            let v1 = ["LOCAL": this_package] // 【软件源地址 ： 【属性 ： 属性值】】
                            package[this_package["PACKAGE"]!]!.version[this_package["VERSION"]!] = v1
                            // 因为存在软件包 所以我们更新一下 SIG 字段
                            package[this_package["PACKAGE"]!]!.signal = ""
                            package[this_package["PACKAGE"]!]!.one_of_the_package_name_lol = this_package["NAME"] ?? ""
                        } else {
                            // 不存在软件包 创建软件包
                            let new = DBMPackage()
                            new.id = this_package["PACKAGE"]!
                            // latest_update_time 我们去写入数据库的时候更新
                            let v1 = ["LOCAL": this_package] // 【软件源地址 ： 【属性 ： 属性值】】
                            new.version[this_package["VERSION"]!] = v1
                            new.one_of_the_package_name_lol = this_package["NAME"] ?? ""
                            new.latest_update_time = now
                            package[this_package["PACKAGE"]!] = new
                        }
                        this_package = [String : String]()
                        has_a_maohao = false
                        break inner
                    }
                    line_break = true
                    in_head = true
                    if info_head == "" || info_body == "" {
                        has_a_maohao = false
                        break inner
                    }
                    while info_head.hasPrefix("\n") {
                        info_head = String(info_head.dropFirst())
                    }
                    info_body = String(info_body.dropFirst())
                    while info_body.hasPrefix(" ") {
                        info_body = String(info_body.dropFirst())
                    }
                    this_package[info_head.uppercased()] = info_body
                    info_head = ""
                    info_body = ""
                    if in_head {
                        info_head += c
                    }
                } else {
                    line_break = false
                    if in_head {
                        info_head += c
                    } else {
                        info_body += c
                    }
                }
            }
            
        } // do
        
        for item in package {
            item.value.signal = "LOCAL"
        }
        
        // 写入更新
        if LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE_SESSION"] != session {
            return
        }
        for key_pair_value in package  {
            try? LKRoot.root_db?.insertOrReplace(objects: key_pair_value.value, intoTable: common_data_handler.table_name.LKRecentInstalled.rawValue)
        }
        // 删除全部没有找到的软件包
        try? LKRoot.root_db?.delete(fromTable: common_data_handler.table_name.LKRecentInstalled.rawValue,
                                    where: DBMPackage.Properties.signal == "BEGIN_UPDATE")
        
        // 重新读取带有最后更新时间数据的数据 lololololol
        let read_again: [DBMPackage]? = try? LKRoot.root_db?.getObjects(fromTable: common_data_handler.table_name.LKRecentInstalled.rawValue)
        package.removeAll()
        for item in read_again ?? [] {
            package[item.id] = item
        }
        LKRoot.container_packages_installed_DBSync = package
        
        LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE"] = "FALSE"
        
        LKRoot.manager_reg.ya.re_sync()
        if LKRoot.manager_reg.ya.initd {
            DispatchQueue.main.async {
                LKRoot.manager_reg.ya.update_user_interface {
                    
                }
            }
        }
        
        print("[*] 更新已安装完成")
        CallB(operation_result.success.rawValue)
    }
    
}
