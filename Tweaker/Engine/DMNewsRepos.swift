//
//  DMNewsRepos.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// MARK: RAM

class DMNewsRepo {
    
    public var name         = String()
    public var link         = String()
    public var language     = [String]()
    public var title        = String()
    public var sub_title    = String()
    public var icon         = String()
    
}

// MARK: DATABASE
class DBMNewsRepo: WCDBSwift.TableCodable {
    
    var link: String?
    var content: String?
    var sort_id: Int?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DBMNewsRepo
        
        case link = "link"
        case content = "content"
        case sort_id = "sort_id"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                link: ColumnConstraintBinding(isPrimary: true, isUnique: true)
            ]
        }
    }
    
}
