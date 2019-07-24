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
    
    // swiftlint:disable:next weak_delegate
    let ins_operation_delegate = AppOperationDelegate()
    // swiftlint:disable:next weak_delegate
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
    
    func submit() -> (operation_result, String) {
        
        // 再次检查表单 <- 晚点再写吧我对我自己粗查代码还是很自信的
        ins_operation_delegate.printStatus()
        
        var auto_install = [String]()
        var required_install = [String]()
        var required_reinstall = [String]()
        var required_remove = [String]()
        
        for item in ins_operation_delegate.operation_queue {
            var thisSection = ""
            switch item.operation_type {
            case .required_install, .required_reinstall:
                // 拷贝安装资源
                if let path = item.dowload?.path {
                    if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.copyItem(atPath: path, toPath: LKRoot.root_path! + "/daemon.call/debs/" + UUID().uuidString + ".deb")
                        thisSection = "dpkg -i " + LKRoot.root_path! + "/daemon.call/debs/" + UUID().uuidString + ".deb"
                        if item.operation_type == .required_install {
                            required_install.append(thisSection)
                        } else {
                            required_reinstall.append(thisSection)
                        }
                    } else {
                        return (.failed, item.package.id)
                    }
                } else {
                    return (.failed, item.package.id)
                }
            case .required_remove:
                required_remove.append("dpkg --remove " + item.package.id)
            case .required_config:
                print("required_config")
            case .required_modify_dcrp:
                print("required_modify_dcrp")
            case .auto_install:
                // 拷贝安装资源
                if let path = item.dowload?.path {
                    if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.copyItem(atPath: path, toPath: LKRoot.root_path! + "/daemon.call/debs/" + UUID().uuidString + ".deb")
                        thisSection = "dpkg -i " + LKRoot.root_path! + "/daemon.call/debs/" + UUID().uuidString + ".deb"
                        auto_install.append(thisSection)
                    } else {
                        return (.failed, item.package.id)
                    }
                } else {
                    return (.failed, item.package.id)
                }
            case .DNG_auto_remove:
                print("apt autoremove")
            case .unknown:
                print("unknown")
            }
        }
        
        var script = ""
        for item in auto_install + required_reinstall + required_install + required_remove {
            script += item + " &>> " + LKRoot.root_path! + "/daemon.call/out.txt ;\n"
        }
        
        try? script.write(toFile: LKRoot.root_path! + "/daemon.call/requsetScript.txt", atomically: true, encoding: .utf8)
        try? FileManager.default.removeItem(atPath: LKRoot.root_path! + "/daemon.call/out.txt")
        try? "".write(toFile: LKRoot.root_path! + "/daemon.call/out.txt", atomically: true, encoding: .utf8)
        
        print("---- Script ----")
        print("")
        print(script)
        print("---- ------ ----")
        
        
        daemon_msg_pass(msg: "init:req:fromScript")
        
        if status != .ready {
            return (.failed, "Saily.Daemon")
        }
        
        // 打开监视窗口
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
        }
        
        return (.success, "")
    }
    
}
