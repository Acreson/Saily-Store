//
//  AppDaemonUtils.swift
//  Saily
//
//  Created by Lakr Aream on 2019/7/20.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

enum daemon_status: String {
    case ready
    case busy
    case offline
}

let LKDaemonUtils = app_daemon_utils()

class app_daemon_utils {
    
    var session = ""
    var sender_lock = false
    var initialized = false
    let object = LKCBObject()
    
    var status = daemon_status.offline
    
    let ins_operation_delegate = AppOperationDelegate()
    let ins_download_delegate = AppDownloadDelegate()
    
    func initializing() {
        if LKDaemonUtils.session != "" {
            fatalError("[E] LKDaemonUtils 只允许初始化一次 只允许拥有一个实例")
        }
        self.session = UUID().uuidString
        self.initialized = true
        print("[*] App_daemon_utils initialized.")
        LKRoot.queue_dispatch.async {
            self.checkDaemonOnline { (ret) in
                print("[*] 获取到 Dameon 状态： " + ret.rawValue)
                self.status = ret
            }
        }
    }
    
    func daemon_msg_pass(msg: String) {
        if sender_lock == true {
            print("[-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-]")
            print("[-] [-] [-] [-] [-] 发送器已上锁请检查线程安全!! [-] [-] [-] [-] [-] [-]")
            print("[-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-] [-]")
            presentSwiftMessageError(title: "未知错误".localized(), body: "向权限经理发送消息失败".localized())
            LKRoot.breakPoint()
            return
        }
        sender_lock = true
        object.call_to_daemon_(with: "com.Lakr233.Saily.MsgPass.read.Begin")
        usleep(233)
        let charasets = msg.charactersArray
        for item in charasets {
            let cs = String(item)
            let str = "com.Lakr233.Saily.MsgPass.read." + cs
            object.call_to_daemon_(with: str)
            usleep(666)
        }
        object.call_to_daemon_(with: "com.Lakr233.Saily.MsgPass.read.End")
        usleep(233)
        print("[*] 向远端发送数据完成：" + msg)
        sender_lock = false
    }
    
    func checkDaemonOnline(_ complete: @escaping (daemon_status) -> Void) {
        try? FileManager.default.removeItem(atPath: LKRoot.root_path! + "/daemon.call/status.txt")
        LKRoot.queue_dispatch.async {
            self.daemon_msg_pass(msg: "init:path:" + LKRoot.root_path!)
            usleep(233)
            self.daemon_msg_pass(msg: "init:status:required_call_back")
            var cnt = 0
            while cnt < 666 {
                usleep(2333)
                if FileManager.default.fileExists(atPath: LKRoot.root_path! + "/daemon.call/status.txt") {
                    if let str_read = try? String(contentsOfFile: LKRoot.root_path! + "/daemon.call/status.txt") {
                        switch str_read {
                        case "ready\n": complete(daemon_status.ready); return
                        case "busy\n": complete(daemon_status.busy); return
                        default:
                            cnt += 1
                        }
                    }
                }
                cnt += 1
            }
            complete(daemon_status.offline)
        }
    }
    
    
    
}
