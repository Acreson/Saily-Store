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
        
        // 检查依赖并且添加
        if let dependStr = pack.version.first?.value.first?.value["DEPENDS"] {
            let checkResult = LKRoot.ins_common_operator.PAK_read_missing_dependency(dependStr: dependStr)
            print("[*] 软件包依赖检查结果：" + checkResult.debugDescription)
            for missing_dep in checkResult {
                if let dep_package = LKRoot.container_packages[missing_dep.key] {
                    // 找到了软件包 接下来 检查软件包是否合法
                    if add_install(pack: dep_package, required_install: false).0 == .failed {
                        // 添加失败 上报一个错误
                        let err = unMatched(ID: missing_dep.key, dep: missing_dep.value)
                        unsolved_condition.append(err)
                    }
                } else {
                    // 没找到软件包 既然没有那怎么可能出现在安装队列呢？
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
    
    func add_uninstall() {
        
    }
    
}

