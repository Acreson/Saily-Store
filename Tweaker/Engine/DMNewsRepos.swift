//
//  DMNewsRepos.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// MARK: RAM

class DMNewsRepo {
    
    public var name                 = String()
    public var link                 = String()
    public var language             = [String]()
    public var title                = String()
    public var sub_title            = String()
    public var icon                 = String()
    
    public var title_color          = String()
    public var subtitle_color       = String()
    
    public var cards                = [DMNewsCard]()
    
}

// MARK: DATABASE
class DBMNewsRepo: WCDBSwift.TableCodable {
    
    var link: String?
    var content: String?
    var sort_id: Int?
    
    enum CodingKeys: String, CodingTableKey { // swiftlint:disable:next nesting
        typealias Root = DBMNewsRepo
        
        // swiftlint:disable:next redundant_string_enum_value
        case link = "link"
        // swiftlint:disable:next redundant_string_enum_value
        case content = "content"
        // swiftlint:disable:next redundant_string_enum_value
        case sort_id = "sort_id"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                link: ColumnConstraintBinding(isPrimary: true, isUnique: true)
            ]
        }
    }
    
}
