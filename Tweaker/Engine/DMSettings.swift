//
//  DMSettings.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// MARK: RAM
// 不要啊啊啊啊啊啊啊

// MARK: DATABASE


class DBMSettings: WCDBSwift.TableCodable {
    
    var fake_UDID: String?
    var real_UDID: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DBMSettings
        
        case fake_UDID = "fake_UDID"
        case real_UDID = "real_UDID"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
    }
    
}
