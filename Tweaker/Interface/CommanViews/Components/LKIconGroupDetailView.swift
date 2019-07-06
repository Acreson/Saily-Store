//
//  LKIconGroupDetailView.swift
//  LKIconGroupDetailView
//
//  Created by Lakr Aream on 2019/6/6.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation
import UIKit

class LKIconGroupDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var lenth = 233
    var table_view = UITableView()
    let sep = UIView()
    var table_view_icon_source = [String]()
    var table_view_title_source = [String]()
    var table_view_describe_source = [String]()
    
    var is_collapsed = true
    var collapsed_button = UIButton()
    
    var padding_insert = [0, 0, 0, 0]
    var content_view = UIView()
    var shadow_view = UIView()
    
    var title_view = UILabel()
    var title_color = UIColor()
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
    
    func apart_init(collapsed: Bool = true, title: String, sub_title: String, title_color: UIColor, sub_title_color: UIColor, icon_addrs: [String]) {
        
        is_collapsed = collapsed
        self.title_color = title_color
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
            x.top.equalTo(self.snp.top)
            x.left.equalTo(self.snp.left)
            x.right.equalTo(self.snp.right)
        }
        shadow_view.addShadow(ofColor: LKRoot.ins_color_manager.read_a_color("shadow"))
        
        // 标题
        title_view.text = title
        title_view.textColor = title_color
        title_view.font = .boldSystemFont(ofSize: 28)
        addSubview(title_view)
        title_view.snp.makeConstraints { (x) in
            x.top.equalTo(self.content_view.snp.top).offset(6)
            x.left.equalTo(self.content_view.snp.left).offset(16)
            x.height.equalTo(46)
            x.width.equalTo(188)
        }
        
        // 描述
        sub_title_view.text = sub_title
        sub_title_view.textColor = sub_title_color
        sub_title_view.font = .systemFont(ofSize: 10)
        sub_title_view.isUserInteractionEnabled = false
        addSubview(sub_title_view)
        sub_title_view.snp.makeConstraints { (x) in
            x.top.equalTo(title_view.snp.bottom).offset(0)
            x.left.equalTo(self.content_view.snp.left).offset(12)
            x.right.equalTo(self.content_view.snp.right).offset(-12)
            x.height.equalTo(sub_title_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 92, height: .infinity)))
        }
        
        // 分割线
        sep.backgroundColor = LKRoot.ins_color_manager.read_a_color("tabbar_untint")
        sep.alpha = 0.3
        addSubview(sep)
        sep.snp.makeConstraints { (x) in
            x.top.equalTo(sub_title_view.snp.bottom)
            x.left.equalTo(self.content_view.snp.left)
            x.right.equalTo(self.content_view.snp.right)
            x.height.equalTo(0.5)
        }
        
        // 图标组
        let icon_stack = LKIconStack()
        icon_stack.images_address = icon_addrs
        icon_stack.apart_init()
        self.addSubview(icon_stack)
        icon_stack.snp.makeConstraints { (x) in
            x.right.equalTo(self.content_view.snp.right).offset(16)
            x.top.equalTo(self.content_view.snp.top).offset(12)
            x.width.equalTo(2)
            x.height.equalTo(33)
        }
        
        collapsed_button.addTarget(self, action: #selector(collapsed_operator), for: .touchUpInside)
        collapsed_operator()
    }
    
    @objc func collapsed_operator() {
        if is_collapsed {
            if collapsed_button.superview == nil {
                self.addSubview(collapsed_button)
            }
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.sep.backgroundColor = LKRoot.ins_color_manager.read_a_color("tabbar_untint")
                self.sep.snp.remakeConstraints({ (x) in
                    x.top.equalTo(self.sub_title_view.snp.bottom)
                    x.left.equalTo(self.content_view.snp.left)
                    x.right.equalTo(self.content_view.snp.right)
                    x.height.equalTo(0.5)
                })
            }, completion: nil)
            collapsed_button.setTitle("点击来展开全部 ▼", for: .normal)
            collapsed_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            collapsed_button.setTitleColor(title_color, for: .normal)
            collapsed_button.setTitleColor(.gray, for: .focused)
            collapsed_button.snp.remakeConstraints { (x) in
                x.bottom.equalTo(self.content_view.snp.bottom)
                x.top.equalTo(sep.snp.bottom)
                x.left.equalTo(self.content_view.snp.left)
                x.right.equalTo(self.content_view.snp.right)
            }
            is_collapsed = false
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.sep.backgroundColor = .clear
                self.sep.snp.remakeConstraints({ (x) in
                    x.top.equalTo(self.sub_title_view.snp.bottom)
                    x.left.equalTo(self.content_view.snp.left)
                    x.right.equalTo(self.content_view.snp.right)
                    x.height.equalTo(self.table_view_title_source.count * 62)
                })
            }, completion: nil)
            collapsed_button.setTitle("点击来合上选项卡 ▲", for: .normal)
            is_collapsed = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table_view_title_source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

class LKIconStack: UIView {
    
    var image_views = [UIImageView]()
    var images_address = [String]()
    
    func validating_datas() -> Bool {
        if image_views.count == 0 || images_address.count == 0 {
            return false
        }
        if image_views.count != images_address.count {
            print("[Resumable - fatalError] image_views.count != images_address.count")
            return false
        }
        return true
    }
    
    func apart_init() {
        self.clipsToBounds = false
        if images_address.count < 1 {
            print("[Resumable - fatalError] images_address.count < 1")
            return
        }
        let dummy = UIView()
        self.addSubview(dummy)
        dummy.snp.makeConstraints { (x) in
            x.top.equalTo(self.snp.top)
            x.right.equalTo(self.snp.right).offset(-12)
            x.width.equalTo(4)
            x.height.equalTo(33)
        }
        var anchor = dummy
        for _ in 0..<images_address.count {
            let new = UIImageView()
            let bloder = UIView()
            self.addSubview(bloder)
            bloder.backgroundColor = LKRoot.ins_color_manager.read_a_color("icon_ring_tint")
            bloder.setRadiusCGF(radius: 16.5)
            bloder.addShadow(ofColor: LKRoot.ins_color_manager.read_a_color("shadow"))
            bloder.clipsToBounds = false
            self.addSubview(new)
            new.clipsToBounds = true
            new.contentMode = .scaleAspectFill
            bloder.snp.makeConstraints { (x) in
                x.top.equalTo(self.snp.top)
                x.right.equalTo(anchor.snp.right).offset(-16)
                x.width.equalTo(33)
                x.height.equalTo(33)
            }
            new.snp.makeConstraints { (x) in
                x.center.equalTo(bloder.snp.center)
                x.width.equalTo(30)
                x.height.equalTo(30)
            }
            new.setRadiusCGF(radius: 15)
            image_views.append(new)
            anchor = new
        }
        if !validating_datas() {
            return
        }
        update_image()
    }
    
    func update_image() {
        if !validating_datas() {
            return
        }
        for i in 0..<image_views.count {
            image_views[i].sd_setImage(with: URL(string: images_address[i]), placeholderImage: UIImage(named: "Gary")) { (img, err, _, _) in
                if err != nil || img == nil {
                    self.image_views[i].image = UIImage(named: self.images_address[i])
                }
            }
        }
    }
    
}
