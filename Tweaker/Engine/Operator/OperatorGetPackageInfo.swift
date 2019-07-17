//
//  OperatorGetPackageInfo.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension app_opeerator {
    
    func PAK_read_name(pack: DBMPackage, version: [String : [String : String]]) -> String {
        return version.first?.value["NAME"] ?? version.first?.value["PACKAGE"] ?? ""
    }
    
    func PAK_read_description(pack: DBMPackage, version: [String : [String : String]]) -> String {
        return version.first?.value["DESCRIPTION"] ?? ""
    }
    
    func PAK_read_icon_addr(pack: DBMPackage, version: [String : [String : String]]) -> String {
        return version.first?.value["ICON"] ?? ""
    }
    
    func PAK_read_newest_version(pack: DBMPackage) -> (String, [String : [String : String]]) {
        // 先获得全部 version 的数组
        var vers = [String]()
        for item in pack.version {
            vers.append(item.key)
        }
        let newest = version_cmp(vers: vers)
        return (newest, (pack.version[newest] ?? PAK_return_error_vision()))
    }
    
    func PAK_return_error_vision() -> [String : [String : String]] {
        return ["-1" : ["PACKAGE" : "错误的软件包识别码", "NAME" : "未知错误", "DESCRIPTION" : "在获取这个软件包时出现了意外错误。", "ICON" : "NAMED:Error"]]
    }
    
}
