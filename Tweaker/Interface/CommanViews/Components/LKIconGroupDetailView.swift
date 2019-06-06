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
    
    var lenth = 233
    
    var padding_insert = [0, 0, 0, 0]
    var content_view = UIView()
    var shadow_view = UIView()
    
    var title_view = UILabel()
    var sub_title_view = UITextView()
    
    enum tint_type: Int {
        case button    = 0x01
        case icons     = 0x02
        case tint_text = 0x03
    }
    
    enum body_type: Int {
        case table     = 0x11
        case text_icon = 0x02
        
    }
    
    func apart_init(title: String, sub_title: String, title_color: UIColor, sub_title_color: UIColor) {
        
        // 基础和背景
        addSubview(shadow_view)
        addSubview(content_view)
        shadow_view.clipsToBounds = false
        shadow_view.setRadiusCGF(radius: 8)
        shadow_view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_back_ground")
        content_view.setRadiusCGF(radius: 8)
        content_view.clipsToBounds = true
        content_view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_back_ground")
        shadow_view.snp.makeConstraints { (x) in
            x.edges.equalTo(content_view.snp.edges)
        }
        content_view.snp.makeConstraints { (x) in
            x.edges.equalTo(self.snp.edges)
        }
        shadow_view.addShadow(ofColor: LKRoot.ins_color_manager.read_a_color("shadow"))
        
        // 标题
        title_view.text = title
        title_view.textColor = title_color
        title_view.font = .boldSystemFont(ofSize: 26)
        addSubview(title_view)
        title_view.snp.makeConstraints { (x) in
            x.top.equalTo(self.snp.top).offset(12)
            x.left.equalTo(self.snp.left).offset(16)
        }
        
        // 描述
        sub_title_view.text = sub_title
        sub_title_view.textColor = sub_title_color
        sub_title_view.font = .systemFont(ofSize: 10)
        sub_title_view.isUserInteractionEnabled = false
        addSubview(sub_title_view)
        sub_title_view.snp.makeConstraints { (x) in
            x.top.equalTo(title_view.snp.bottom).offset(0)
            x.left.equalTo(self.snp.left).offset(12)
            x.right.equalTo(self.snp.right).offset(-12)
            x.height.equalTo(sub_title_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 92, height: .infinity)))
        }
        
        // 分割线
        let sep = UIView()
        sep.backgroundColor = LKRoot.ins_color_manager.read_a_color("tabbar_untint")
        sep.alpha = 0.3
        addSubview(sep)
        sep.snp.makeConstraints { (x) in
            x.top.equalTo(sub_title_view.snp.bottom)
            x.left.equalTo(self.snp.left)
            x.right.equalTo(self.snp.right)
            x.height.equalTo(0.5)
        }
        
    }
    
}

class LKIconStack: UIView {
    
    
    
}
