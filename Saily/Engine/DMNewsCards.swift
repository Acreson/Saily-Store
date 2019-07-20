//
//  DMNewsCards.swift
//  Saily
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// 卡片的 KEY 使用随机生成的 UUID
// 是主键，具有唯一性。

// MARK: RAM
class DMNewsCard {
    
    public var type: card_type                     = .photo_full
    
    public var content: String?                    = String()
    
    public var image_container                     = [String]()
    
    public var main_title_string                   = String()
    public var sub_title_string:       String?
    public var last_update_string:     String?
    public var description_string:     String?
    
    public var main_title_string_color             = String()
    public var sub_title_string_color              = String()
    public var last_update_string_color            = String()
    public var description_string_color            = String()
    
}

// 卡片不予以缓存本地
