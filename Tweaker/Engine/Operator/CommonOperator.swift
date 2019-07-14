//
//  CommonOperator.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

enum operation_result: Int {
    case success = 0x0
    case failed  = 0x1
    case another_in_progress = 0x2
    case unkown  = 0x666
}

class app_opeerator {
    
    // 检查联网
    func test_network() -> Int {
        let test_url = URL(string: "https://www.apple.com/")!
        let test_network_semaphore = DispatchSemaphore(value: 0)
        var test_result = operation_result.failed.rawValue
        print("[*] 准备从 " + test_url.absoluteString + " 请求数据。")
        AF.request(test_url, method: .post).response(queue: LKRoot.queue_alamofire) { (respond) in
            switch respond.result {
            case .success: test_result = operation_result.success.rawValue
            default: break
            }
            test_network_semaphore.signal()
        }
        LKRoot.queue_dispatch.async {
            sleep(3)
            test_network_semaphore.signal()
        }
        test_network_semaphore.wait()
        return test_result
    }
    
    func version_cmp(vers: [String]) -> String {
        var newest = vers.first ?? ""
        for item in vers where newest.compare(item, options: [.numeric, .literal]) == .orderedDescending {
            newest = item
        }
        return newest
    }
    
}

class networking {
    
    let release_search_path = [
        "Packages.bz2",
        "Packages.gz",
        "dists/stable/main/binary-iphoneos-arm/Packages.bz2",
        "dists/stable/main/binary-iphoneos-arm/Packages.gz",
        "dists/hnd/main/binary-iphoneos-arm/Packages.bz2",
        "dists/tangelo/main/binary-iphoneos-arm/Packages.bz2",
        "dists/tangelo/main/binary-iphoneos-arm/Packages.gz",
        "dists/unstable/main/binary-iphoneos-arm/Packages.bz2",
        "dists/unstable/main/binary-iphoneos-arm/Packages.gz",
        "dists/unstable/main/binary-iphoneos-arm/Packages",
        "dists/stable/main/binary-iphoneos-arm/Packages",
        "dists/tangelo/main/binary-iphoneos-arm/Packages",
        "Packages"
    ]
    
    public let UA_Default             = "Telesphoreo APT-HTTP/1.0.592"
    public let UA_Sileo               = "Sileo/1 CFNetwork/974.2.1 Darwin/18.0.0"
    public let UA_Web_Request_iOS_old = "Cydia/0.9 CFNetwork/342.1 Darwin/9.4.1"
    public let UA_Web_Request_iOS_12  = "Cydia/0.9 CFNetwork/974.2.1 Darwin/18.0.0"
    public let UA_Web_Request_Longer  = "Mozilla/5.0 (iPad; CPU OS 12_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/16A404 Safari/604.1 Cydia/1.1.32~b12 CyF/1556.00"
    
    func read_header() -> HTTPHeaders {
        let header: HTTPHeaders = [
            "User-Agent" : UA_Default,
            "X-Firmware" : LKRoot.shared_device.systemVersion,
            "X-Unique-ID" : LKRoot.settings?.readUDID() ?? "",
            "X-Machine" : LKRoot.shared_device._id_str(),
            "Accept" : "*/*",
            "Accept-Language" : "zh-CN,en,*",
            "Accept-Encoding" : "gzip, deflate"
        ]
        return header
    }
    
}

