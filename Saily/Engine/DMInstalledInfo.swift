//
//  DMInstalledInfo.swift
//  Saily
//
//  Created by Lakr Aream on 2019/7/22.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

enum operation_type_t: String {
    case required_install       // Will Install
    case required_reinstall     // Will reinstall
    case required_remove        // Will remove
    case required_config        // Install failed, will need to reconfig
    case required_modify_dcrp   // Dependency Conflict Replace Provide
    case auto_install           // Dependencies...
    case DNG_auto_remove        // Ask user before execute
    case unknown
}

// MARK: Current Info
enum current_info: String {
    case installed_ok
    case installed_bad
    case not_installed
    case unknown
}

struct dpkg_file {
    var filename: String
    var filepath: String
    var filemd5s: String
}



class DMOperationInfo {

    var priority: Int
    var package: String
    var download_path: String?
    var download_progress: Int?
    var file_path: String?
    var operation_type: operation_type_t
    var current_info: current_info
    
    init() {
        priority = 0
        package = ""
        download_path = ""
        download_progress = 0
        file_path = ""
        operation_type = .unknown
        current_info = .unknown
        fatalError("[E] DMOperationInfo 不允许被空初始化")
    }
    
    required init(packid: String, operation: operation_type_t) {
        if operation != .required_config && operation != .required_remove {
            fatalError("[E] DMOperationInfo 不允许使用软件包识别码进行除配置和删除以外的操作")
        }
        priority = 0
        package = packid
        operation_type = operation
        current_info = LKRoot.ins_common_operator.PAK_read_current_status(packID: packid)
    }
    
    required init(packid: String, download_from: String, operation: operation_type_t) {
        if operation == .unknown {
            fatalError("[E] DMOperationInfo 不允许使用未知的操作进行初始化")
        }
        priority = 0
        package = packid
        download_path = download_from
        download_progress = 0
        file_path = LKRoot.root_path! + "/daemon.call/debs/" + packid.description
        operation_type = operation
        current_info = LKRoot.ins_common_operator.PAK_read_current_status(packID: packid)
    }
    
}

