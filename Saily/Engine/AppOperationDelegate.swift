//
//  AppOperationDelegate.swift
//  Saily
//
//  Created by Lakr Aream on 2019/7/23.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class AppOperationDelegate {
    var operation_queue = [DMOperationInfo]()
    
    func add_install(pack: DBMPackage) -> (operation_result, dld_info?) {
        
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
        
        let operation_info = DMOperationInfo(packid: pack.id, operation: .required_install)
        operation_queue.append(operation_info)
        
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

