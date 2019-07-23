//
//  AppOperationDelegate.swift
//  Saily
//
//  Created by Lakr Aream on 2019/7/23.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

struct unMatched {
    let ID: String
    let dep: depends
}

class AppOperationDelegate {
    
    var operation_queue = [DMOperationInfo]()
    var unsolved_condition = [unMatched]()
    
    func printStatus() {
        print("--> 操作队列")
        for item in operation_queue {
            let name: String = item.package
            let curinfo: String = item.current_info.rawValue
            let to: String = item.operation_type.rawValue
            let p: String = String(item.priority)
            var printStr: String = "---> 软件包 - " + name
                printStr += "    " + curinfo
                printStr += " -> " + to
                printStr += " | " + p
            print(printStr)
        }
        for item in unsolved_condition {
            var printStr: String = "[*] ---> 未解决的问题 - " + item.ID
                printStr += " <-> " + item.dep.req.rawValue
                printStr += " " + item.dep.ver
            print(printStr)
        }
    }
    
    func add_install(pack: DBMPackage, required_install: Bool = true) -> (operation_result, dld_info?) {
        
        // 校验软件包数据合法性
        if pack.version.count != 1 || pack.version.first!.value.count != 1 {
            presentStatusAlert(imgName: "Warning", title: "错误".localized(), msg: "软件包信息校验失败，请尝试刷新。".localized())
            return (.failed, nil)
        }
        
        guard let repolink = pack.version.first?.value.first?.key else {
            presentStatusAlert(imgName: "Warning", title: "错误".localized(), msg: "软件包信息校验失败，请尝试刷新。".localized())
            return (.failed, nil)
        }
        
        guard let filePath = pack.version.first?.value.first?.value["Filename".uppercased()] else {
            presentStatusAlert(imgName: "Warning", title: "错误".localized(), msg: "软件包信息校验失败，请尝试刷新。".localized())
            return (.failed, nil)
        }
        
        var exists = false
        for item in operation_queue where item.package == pack.id {
            exists = true
        }
        if !exists {
            if required_install {
                let operation_info = DMOperationInfo(packid: pack.id, operation: .required_install)
                operation_queue.append(operation_info)
            } else {
                let operation_info = DMOperationInfo(packid: pack.id, operation: .auto_install)
                operation_queue.append(operation_info)
            }
        }
        
        printStatus()
        
        // 检查依赖并且添加
        if let dependStr = pack.version.first?.value.first?.value["DEPENDS"] {
            let checkResult = LKRoot.ins_common_operator.PAK_read_missing_dependency(dependStr: dependStr)
            print("[*] 软件包依赖检查结果：" + checkResult.debugDescription)
            inner: for missing_dep in checkResult {
                if let dep_package = LKRoot.container_packages[missing_dep.key] {
                    // 再次检查以免被内循环添加之后重复添加
                    for re_check in operation_queue where re_check.package == missing_dep.key {
                        // 内循环添加 跳过
                        continue inner
                    }
                    // 找到了软件包 接下来 处理软件包 只保留一个version
                    let _pack = dep_package.copy()
                    let targetVersion = LKRoot.ins_common_operator.PAK_read_newest_version(pack: _pack)
                    _pack.version.removeAll()
                    _pack.version[targetVersion.0] = [targetVersion.1.first?.key ?? "" : targetVersion.1.first?.value ?? ["" : ""]]
                    if add_install(pack: _pack, required_install: false).0 == .failed {
                        // 添加失败 上报一个错误
                        let err = unMatched(ID: missing_dep.key, dep: missing_dep.value)
                        unsolved_condition.append(err)
                    }
                } else {
                    // 没找到软件包 既然没有那怎么可能出现在安装队列呢？
                    
                    // 但是我们要先检查一下这个错误是不是已经被上报了
                    for reported in unsolved_condition where reported.ID == missing_dep.key {
                        // 已经被上报 不管要求怎样肯定不对 就先不管她了
                        continue inner
                    }
                    // 上报一个错误
                    let err = unMatched(ID: missing_dep.key, dep: missing_dep.value)
                    unsolved_condition.append(err)
                }
            }
        }
        
        var ret: (operation_result, dld_info?) = (operation_result.failed, nil)
        if let sha256 = pack.version.first?.value.first?.value["SHA256"] {
            ret = LKDaemonUtils.ins_download_delegate.submit_download(packID: pack.id, fromRepo: repolink, networkPath: repolink + filePath, UA_required: true, sha256: sha256)
        } else {
            ret = LKDaemonUtils.ins_download_delegate.submit_download(packID: pack.id, fromRepo: repolink, networkPath: repolink + filePath, UA_required: true, sha256: nil)
        }
        
        return ret
        
    }
    
    func cancel_add_install(packID: String) {
        
    }
    
    func add_uninstall() {
        
    }
    
}

