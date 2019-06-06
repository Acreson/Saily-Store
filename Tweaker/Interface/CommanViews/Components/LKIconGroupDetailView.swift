//
//  LKIconGroupDetailView.swift
//  LKIconGroupDetailView
//
//  Created by Lakr Aream on 2019/6/6.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation
import UIKit

class LKIconGroupDetailView: UIView {
    
    var padding_insert = [0, 0, 0, 0]
    var content_view = UIView()
    var shadow_view = UIView()
    
    enum tint_type: Int {
        case button    = 0x01
        case icons     = 0x02
        case tint_text = 0x03
    }
    
    enum body_type: Int {
        case table     = 0x11
        case text_icon = 0x02
        
    }
    
    func apart_init() {
        
        addSubview(shadow_view)
        addSubview(content_view)
        
        shadow_view.snp.makeConstraints { (x) in
            x.edges.equalTo(content_view.snp.edges)
        }
        
    }
    
}

class LKIconStack: UIView {
    
    
    
}
