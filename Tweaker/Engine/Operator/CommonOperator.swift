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
        test_network_semaphore.wait()
        return test_result
    }
    
}



