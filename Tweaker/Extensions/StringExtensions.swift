//
//  String+Extension.swift
//  Saily
//
//  Created by mac on 2019/5/11.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation

extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func drop_space() -> String {
        var ret = self
        while ret.hasPrefix(" ") {
            ret = ret.dropFirst().to_String()
        }
        while ret.hasSuffix(" ") {
            ret = ret.dropLast().to_String()
        }
        return ret
    }
    
}

extension Substring {
    
    func to_String() -> String {
        return String(self)
    }
    
}
