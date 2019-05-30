//
//  CreateCard.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/30.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension common_views {
    
    func NPCD_create_card(info: DMNewsCard) -> UIView {
        let ret = UIView()
        ret.clipsToBounds = true
        switch info.type {
        case .photo_full:
            do {
                // 图片底
                if let image_url = URL(string: info.image_container.first ?? "") {
                    let bg = UIImageView()
                    bg.sd_setImage(with: image_url, placeholderImage: UIImage(named: "SDWebImagePlaceHolder"))
                    bg.contentMode = .scaleAspectFill
                    bg.clipsToBounds = true
                    ret.addSubview(bg)
                    bg.snp.makeConstraints { (x) in
                        x.top.equalTo(ret.snp.top)
                        x.left.equalTo(ret.snp.left)
                        x.bottom.equalTo(ret.snp.bottom)
                        x.right.equalTo(ret.snp.right)
                    }
                } else {
                    let bg = UIView()
                    bg.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                    ret.addSubview(bg)
                    bg.snp.makeConstraints { (x) in
                        x.top.equalTo(ret.snp.top)
                        x.left.equalTo(ret.snp.left)
                        x.bottom.equalTo(ret.snp.bottom)
                        x.right.equalTo(ret.snp.right)
                    }
                    
                }
                // 俩标题
                let sub_title = UILabel(text: info.sub_title_string)
                sub_title.font = UIFont(name: ".SFUIText-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
                if let color = UIColor(hexString: info.sub_title_string_color) {
                    sub_title.textColor = color
                } else {
                    sub_title.textColor = .white
                }
                let title = UILabel(text: info.main_title_string)
                title.font = UIFont(name: ".SFUIText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22)
                if let color = UIColor(hexString: info.main_title_string) {
                    title.textColor = color
                } else {
                    title.textColor = .white
                }
                ret.addSubview(sub_title)
                ret.addSubview(title)
                sub_title.snp.makeConstraints { (x) in
                    x.top.equalTo(ret.snp.top).offset(18)
                    x.left.equalTo(ret.snp.left).offset(18)
                }
                title.snp.makeConstraints { (x) in
                    x.top.equalTo(sub_title.snp.bottom).offset(2)
                    x.left.equalTo(sub_title.snp.left).offset(0)
                }
                // 底下的文字
                let des_str = UITextView()
                des_str.text = info.description_string
                des_str.font = UIFont(name: ".SFUIText-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
                des_str.isUserInteractionEnabled = false
                des_str.backgroundColor = .clear
                if let color = UIColor(hexString: info.description_string_color) {
                    des_str.textColor = color
                } else {
                    des_str.textColor = .white
                }
                
                ret.addSubview(des_str)
                des_str.snp.makeConstraints { (x) in
                    x.left.equalTo(ret.snp.left).offset(18)
                    x.right.equalTo(ret.snp.right).offset(-18)
                    x.bottom.equalTo(ret.snp.bottom).offset(-18)
                    x.height.equalTo(48)
                }
            }
        case .photo_half_with_banner_down_light:
            do {
                ret.backgroundColor = .white
                // 图片底
                if let image_url = URL(string: info.image_container.first ?? "") {
                    let bg = UIImageView()
                    bg.sd_setImage(with: image_url, placeholderImage: UIImage(named: "SDWebImagePlaceHolder"))
                    bg.contentMode = .scaleAspectFill
                    bg.clipsToBounds = true
                    ret.addSubview(bg)
                    bg.snp.makeConstraints { (x) in
                        x.top.equalTo(ret.snp.top)
                        x.left.equalTo(ret.snp.left)
                        x.bottom.equalTo(ret.snp.centerY).offset(28)
                        x.right.equalTo(ret.snp.right)
                    }
                } else {
                    let bg = UIView()
                    bg.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                    ret.addSubview(bg)
                    bg.snp.makeConstraints { (x) in
                        x.top.equalTo(ret.snp.top)
                        x.left.equalTo(ret.snp.left)
                        x.bottom.equalTo(ret.snp.centerY).offset(28)
                        x.right.equalTo(ret.snp.right)
                    }
                    
                }
                // 底下的文字
                let des_str = UILabel()
                des_str.text = info.description_string
                des_str.font = UIFont(name: ".SFUIText-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
                if let color = UIColor(hexString: info.description_string_color) {
                    des_str.textColor = color
                } else {
                    des_str.textColor = .gray
                }
                
                ret.addSubview(des_str)
                des_str.snp.makeConstraints { (x) in
                    x.left.equalTo(ret.snp.left).offset(18)
                    x.right.equalTo(ret.snp.right).offset(-18)
                    x.bottom.equalTo(ret.snp.bottom).offset(-12)
                }
                // 俩标题
                let sub_title = UILabel(text: info.sub_title_string)
                sub_title.font = UIFont(name: ".SFUIText-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
                if let color = UIColor(hexString: info.sub_title_string_color) {
                    sub_title.textColor = color
                } else {
                    sub_title.textColor = .gray
                }
                let title = UITextView()
                title.text = info.main_title_string
                title.isUserInteractionEnabled = false
                title.font = UIFont(name: ".SFUIText-Bold", size: 26) ?? UIFont.systemFont(ofSize: 26)
                title.backgroundColor = .clear
                if let color = UIColor(hexString: info.main_title_string) {
                    title.textColor = color
                } else {
                    title.textColor = .black
                }
                title.textContainer.maximumNumberOfLines = 2
                title.textContainer.lineBreakMode = .byWordWrapping
                ret.addSubview(sub_title)
                ret.addSubview(title)
                sub_title.snp.makeConstraints { (x) in
                    x.top.equalTo(ret.snp.centerY).offset(42)
                    x.left.equalTo(ret.snp.left).offset(18)
                }
                title.snp.makeConstraints { (x) in
                    x.top.equalTo(sub_title.snp.bottom).offset(0)
                    x.left.equalTo(ret.snp.left).offset(12)
                    x.right.equalTo(ret.snp.right).offset(-12)
                    x.bottom.equalTo(des_str.snp.top).offset(0)
                }
            }
        default:
            print("[*] 这啥玩意哦？")
        }
        return ret
    }
    
}
