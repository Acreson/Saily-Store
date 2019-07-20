//
//  DMNewsRepos.swift
//  Saily
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
        
        case link
        case content
        case sort_id
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                link: ColumnConstraintBinding(isPrimary: true, isUnique: true)
            ]
        }
    }
    
}
