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
            return ret
        default:
            print("[***] 还没写实现，赶紧补一下吧。")
        }
        return .black
    }
 
    let CS_light = ["main_tint_color"               : #colorLiteral(red: 0, green: 0.7235050797, blue: 0.893548429, alpha: 1),    // UIColor(hex: 0x0AAADD),
                    "main_back_ground"              : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),    // UIColor(hex: 0xFFFFFF),
                    "main_operations_attention"     : #colorLiteral(red: 1, green: 0.4896141291, blue: 0.4700677395, alpha: 1),    // UIColor(hex: 0xFF6565),
                    "main_operations_allow"         : #colorLiteral(red: 0, green: 0.8103328347, blue: 0.3696507514, alpha: 1),    // UIColor(hex: 0x0AC94C),
                    "main_title_one"                : #colorLiteral(red: 0.2860272825, green: 0.611161828, blue: 1, alpha: 1),    // UIColor(hex: 0x3B86FF),
                    "main_title_two"                : #colorLiteral(red: 0.6999540329, green: 0.7014504075, blue: 0.9883304238, alpha: 1),    // UIColor(hex: 0xA3A0FB),
                    "main_title_three"              : #colorLiteral(red: 0.3324531913, green: 0.3323239088, blue: 0.4404206276, alpha: 1),    // UIColor(hex: 0x43425D),
        
                    "button_tint_color"             : #colorLiteral(red: 0, green: 0.7235050797, blue: 0.893548429, alpha: 1),    // UIColor(hex: 0x0AAADD),
                    "button_touched_color"          : #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1),    // UIColor(hex: 0xA9A9A9),
                    
                    "submain_title_one"             : #colorLiteral(red: 0.6677469611, green: 0.6677629352, blue: 0.6677542925, alpha: 1)     // UIColor(hex: 0x9A9A9A),
    ]
    
}
