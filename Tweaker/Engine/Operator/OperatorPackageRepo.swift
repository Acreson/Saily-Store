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
        
        for item in repos {
            // 下载内容
            
            
            
            
        }
        
    } // PR_sync_and_download
    
}
