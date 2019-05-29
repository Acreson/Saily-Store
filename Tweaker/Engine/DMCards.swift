//
//  DMCards.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// 卡片的 KEY 使用随机生成的 UUID
// 是主键，具有唯一性。

// MARK: RAM

class DMCard {
    
    public var type: card_type                     = .photo_full
    
    public var main_title_string                   = ""
    public var sub_title_string:       String?
    public var last_update_string:     String?
    public var description_string:     String?
    
}

// MARK: DATABASE

// 当没有网络连接时，从本地读取缓存。
class DBMCard: WCDBSwift.TableCodable {
    
    var KEY: String?
    var type: card_type?
    
    enum CodingKeys: String, CodingTableKey { // swiftlint:disable:next nesting
        typealias Root = DBMCard
        
        // swiftlint:disable:next redundant_string_enum_value
        case KEY = "KEY"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                KEY: ColumnConstraintBinding(isPrimary: true, isUnique: true)
            ]
        }
    }
    
}
