//
//  ColorSheetCommon.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//



class color_sheet {
    
    var current_color_sheet: color_sheet_id = .light
    
    enum color_sheet_id: Int {
        case light = 0x00
        case dark_blue = 0x10
        case dark_black = 0x11
    }
    
    func read_a_color(_ which: String) -> UIColor {
        switch current_color_sheet {
        case .light:
            guard let ret = CS_light[which] else {
                return .black
            }
            guard let non_option_ret = ret else {
                return .black
            }
            return non_option_ret
        default:
            print("[***] 还没写实现，赶紧补一下吧。")
        }
        return .black
    }
 
    let CS_light = ["main_tint_color"               : UIColor(hex: 0x0AAADD),
                    "main_back_ground"              : UIColor(hex: 0xFFFFFF),
                    "main_operations_attention"     : UIColor(hex: 0xFF6565),
                    "main_operations_allow"         : UIColor(hex: 0x0AC94C),
                    "main_title_one"                : UIColor(hex: 0x3B86FF),
                    "main_title_two"                : UIColor(hex: 0xA3A0FB),
                    "main_title_three"              : UIColor(hex: 0x43425D),
                    
                    "submain_title_one"             : UIColor(hex: 0x9A9A9A)
    ]
    
}
