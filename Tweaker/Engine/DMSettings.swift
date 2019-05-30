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
    
    enum CodingKeys: String, CodingTableKey { // swiftlint:disable:next nesting
        typealias Root = DBMSettings
        
        // swiftlint:disable:next redundant_string_enum_value
        case fake_UDID = "fake_UDID"
        // swiftlint:disable:next redundant_string_enum_value
        case real_UDID = "real_UDID"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
    }
    
}