//
//  AppDaemonUtils.swift
//  Saily
//
//  Created by Lakr Aream on 2019/7/20.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

enum operation_type: String {
    case install_user
    case install_auto
    case remove_user
    case remove_auto
}

let LKDaemonUtils = app_daemon_utils()

class app_daemon_utils {
    
    var session = ""
    let object = LKCBObject()
    
    func initializing() {
        
        if LKDaemonUtils.session != "" {
            fatalError("[E] LKDaemonUtils 只允许初始化一次 只允许拥有一个实例")
        }
        session = UUID().uuidString
        
        object.call_to_daemon_(with: "init:path:" + LKRoot.root_path!)
        
    }
    
    
    
}
