//
//  OperatorPackageRepo.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/11.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension app_opeerator {

    func PR_sync_and_download(CallB: @escaping (Int) -> Void) {
        guard let repos: [DBMPackageRepos] = try? LKRoot.root_db?.getObjects(on: [DBMPackageRepos.Properties.link,
                                                                                  DBMPackageRepos.Properties.icon,
                                                                                  DBMPackageRepos.Properties.name,
                                                                                  DBMPackageRepos.Properties.sort_id],
                                                                         fromTable: common_data_handler.table_name.LKPackageRepos.rawValue,
                                                                         orderBy: [DBMPackageRepos.Properties.sort_id.asOrder(by: .ascending)]) else {
                                                                            print("[E] 无法从 LKPackageRepos 中获得数据，终止同步。")
                                                                            LKRoot.container_package_repo.removeAll()
                                                                            CallB(operation_result.failed.rawValue)
                                                                            return
        } // guard let
        
        inner_01: for item in repos where item.link != nil && item.link != "" {
            // 下载内容
            let release_url = (item.link ?? "") + "Release"
            guard let url = URL(string: release_url) else {
                print("[Resumable - fatalError] 无法内容创建下载链接:" + (item.link ?? ""))
                continue inner_01
            }
            var read_release = ""
            let sem = DispatchSemaphore(value: 0)
            var finished = false
            print("[*] 准备从 " + url.absoluteString + " 请求数据。")
            AF.request(url, method: .get, headers: LKRoot.ins_networking.read_header()).response(queue: LKRoot.queue_dispatch) { (data) in
                finished = true
                let str_data = data.data ?? Data()
                var str: String?
                str = String(data: str_data, encoding: .utf8)
                if str == nil {
                    str = String(data: str_data, encoding: .ascii)
                    if str == nil {
                        str = """
                        Label: 未知错误
                        Description: 获取软件源元数据错误
                        """
                    }
                }
                read_release = str ?? ""
                sem.signal()
            }
            LKRoot.queue_dispatch.async {
                sleep(UInt32(LKRoot.settings?.network_timeout ?? 6))
                if !finished {
                    read_release = """
                    Label: 未知错误
                    Description: 获取软件源元数据错误
                    """
                    sem.signal()
                }
            }
            read_release = read_release.cleanRN()
            // 发送给wrapper
            let out = PR_release_wrapper(str: read_release)
            let new = DMPackageRepos()
            new.link = item.link ?? ""
            new.icon = (item.link ?? "") + "CydiaIcon@3x.png"
            new.item = out
            new.name = out["LABEL"] ?? ""
            new.desstr = out["DESCRIPTION"] ?? ""
            LKRoot.container_package_repo.append(new)
            let db = new.to_data_base()
            try? LKRoot.root_db?.update(table: common_data_handler.table_name.LKPackageRepos.rawValue,
                                        on: [DBMPackageRepos.Properties.icon,
                                             DBMPackageRepos.Properties.name],
                                        with: db,
                                        where: DBMPackageRepos.Properties.link == item.link!)
        }
        
    } // PR_sync_and_download
    
    func PR_release_wrapper(str: String) -> [String : String] {
        var ret = [String : String]()
        for item in str.split(separator: "\n") {
            if item.uppercased().hasPrefix("Label:".uppercased()) {
                ret["LABEL"] = item.dropFirst("Label:".count).to_String().drop_space()
            } else if item.uppercased().hasPrefix("Description:".uppercased()) {
                ret["DESCRIPTION"] = item.dropFirst("Description:".count).to_String().drop_space()
            }
        }
        return ret
    }
    
}
