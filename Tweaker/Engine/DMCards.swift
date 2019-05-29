//
//  DMCards.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// 卡片的 KEY 使用随机生成的 UUID
// 是主键，具有唯一性。

// MARK RAM

class DMCards {
    
    var type: card_type                     = .photo_full
    
    var main_title_string                   = ""
    var sub_title_string:       String?
    var last_update_string:     String?
    var description_string:     String?
    
    
}

// MARK DATABASE

class DBMCards: WCDBSwift.TableCodable {
    
    var KEY: String?
    var type: card_type?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DBMCards
        
        case KEY = "KEY"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                KEY: ColumnConstraintBinding(isPrimary: true, isUnique: true)
            ]
        }
    }
    
}
