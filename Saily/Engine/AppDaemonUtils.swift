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
    var initialized = false
    let object = LKCBObject()
    
    func initializing() {
        if LKDaemonUtils.session != "" {
            fatalError("[E] LKDaemonUtils 只允许初始化一次 只允许拥有一个实例")
        }
        self.session = UUID().uuidString
        LKRoot.queue_dispatch.async {
            self.daemon_msg_pass(msg: "init:path:" + LKRoot.root_path!)
            self.initialized = true
            print("[*] App_daemon_utils initialized.")
        }
    }
    
    func daemon_msg_pass(msg: String) {
        object.call_to_daemon_(with: "com.Lakr233.Saily.MsgPas.UIPasteBoard.readBegin")
        usleep(233)
        let charasets = msg.charactersArray
        for item in charasets {
            let cs = String(item)
            let str = "com.Lakr233.Saily.MsgPas.UIPasteBoard.read" + cs
            object.call_to_daemon_(with: str)
            usleep(666)
        }
        object.call_to_daemon_(with: "com.Lakr233.Saily.MsgPas.UIPasteBoard.readEnd")
        usleep(233)
        print("[*] 向远端发送数据完成：" + msg)
    }
    
}
