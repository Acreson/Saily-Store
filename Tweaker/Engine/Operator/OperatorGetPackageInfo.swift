//
//  OperatorGetPackageInfo.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension app_opeerator {
    
    func PAK_read_name(version: [String : [String : String]]) -> String {
        let name = version.first?.value["NAME"] ?? version.first?.value["PACKAGE"] ?? ""
        if name.hasSuffix("for ShortLook") {
            return name.dropLast("for ShortLook".count).to_String()
        }
        return name
    }
    
    func PAK_read_auth_name(version: [String : [String : String]]) -> String {
        let name = version.first?.value["AUTHOR"] ?? version.first?.value["PACKAGE"] ?? ""
        if name.hasSuffix("for ShortLook") {
            return name.dropLast("for ShortLook".count).to_String()
        }
        return name
    }
    
    // 返回 名字 + 📧
    func PAK_read_auth(version: [String : [String : String]]) -> (String, String) {
        let v = version.first?.value["AUTHOR"]
        if v != nil && v != "" {
            if v!.contains("<") && v!.contains("@") && v!.contains(">") {
                let ret = v!.split(separator: "<").first?.to_String().drop_space() ?? "没有作者信息".localized()
                // 尝试获取email
                let some = v!.split(separator: "<").last?.split(separator: ">").last?.to_String().drop_space() ?? ""
                return (ret, some)
            }
            return (v!, "")
        }
        return ("没有作者信息".localized(), "")
    }
    
    func PAK_read_description(version: [String : [String : String]]) -> String {
        return version.first?.value["DESCRIPTION"] ?? ""
    }
    
    func PAK_read_icon_addr(version: [String : [String : String]]) -> String {
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
    
    func PAK_versions_sort(versions: [String : [String : [String : String]]]) -> [String] {
        // 取出所有版本号
        var versionNum = [String]()
        for item in versions {
            versionNum.append(item.key)
        }
        // 校验数据合法性
        if versionNum.count < 2 {
            return versionNum
        }
        for v1 in 0..<versionNum.count {
            for v2 in v1..<(versionNum.count - 1) {
                if versionNum[v2 + 1] == version_cmp(vers: [versionNum[v2], versionNum[v2 + 1]]) {
                    versionNum.swapAt(v2, v2 + 1)
                }
            }
        }
        return versionNum
        
    }
    
}
