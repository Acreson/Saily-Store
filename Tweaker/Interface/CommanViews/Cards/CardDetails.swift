//
//  UICardDetailView.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/6/3.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UICardDetailView: UIView {
    
    var lenth: CGFloat = 28
    var last_view_for_auto_layout: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("???")
    }
    
}

extension common_views {
    
    func NPCD_create_card_detail(info: String) -> UICardDetailView {
        let ret = UICardDetailView()
        
        var last_view = UIView()
        ret.addSubview(last_view)
        last_view.snp.makeConstraints { (x) in
            x.top.equalTo(ret.snp.top).offset(-18)
            x.height.equalTo(0)
            x.left.equalTo(ret.snp.left)
            x.right.equalTo(ret.snp.right)
        }
        
        var content_head: card_detail_type = .LKPrivateAPI_RESVERED
        var content_body = String()
        var content_vfsl = [String]()
        
        run_content_invoker: for item in info.split(separator: "\n") {
            if item.to_String().drop_space() == "//BLANK-LINE//" {
                content_body += "\n"
                continue run_content_invoker
            }
            // 这里 不要删除空格 这是 被 需要 的 ！！！！！！
            let read = item.to_String().drop_comment()
            if read.drop_space().hasPrefix("--> Begin Section |") && read.drop_space().split(separator: "|").count >= 2 {
                // 头
                content_head = .LKPrivateAPI_RESVERED
                content_body = String()
                content_vfsl = [String]()
                
                switch read.drop_space().split(separator: "|")[1].to_String() {
                case "text": content_head = .text
                case "text_inherit_saying": content_head = .text_inherit_saying
                case "photo": content_head = .photo
                case "photo_with_description": content_head = .photo_with_description
                case "news_repo": content_head = .news_repo
                case "package_repo": content_head = .package_repo
                case "package": content_head = .package
                case "LKPrivateAPI_setting_page": content_head = .LKPrivateAPI_setting_page
                default:
                    print("[*] 这啥玩意啊？？？" + read)
                }
                if read.split(separator: "|").count > 2 {
                    for vfsl in read.split(separator: "|").dropFirst().dropFirst() {
                        content_vfsl.append(vfsl.to_String())
                    }
                }
                continue run_content_invoker
            }
            if read.drop_space().hasPrefix("---> End Section") {
                // 尾
                if content_body.hasSuffix("\n") {
                    content_body = content_body.dropLast().to_String()
                }
                let return_this_shit = NPCD_create_card_detail_build_single(type: content_head, body: content_body, vfsl: content_vfsl)
                ret.addSubview(return_this_shit.0)
                return_this_shit.0.snp.makeConstraints { (x) in
                    x.top.equalTo(last_view.snp.bottom).offset(8)
                    x.left.equalTo(ret.snp.left)
                    x.right.equalTo(ret.snp.right)
                    x.height.equalTo(return_this_shit.1)
                }
                last_view = return_this_shit.0
                ret.lenth += return_this_shit.1
                continue run_content_invoker
            }
            // 身子
            content_body += read + "\n"
        }
        
        // 底层分割
        let return_this_shit = NPCD_create_card_detail_build_single(type: .text, body: "\n\n\n", vfsl: [])
        ret.addSubview(return_this_shit.0)
        return_this_shit.0.snp.makeConstraints { (x) in
            x.top.equalTo(last_view.snp.bottom).offset(8)
            x.left.equalTo(ret.snp.left)
            x.right.equalTo(ret.snp.right)
            x.height.equalTo(return_this_shit.1)
        }
        last_view = return_this_shit.0
        ret.lenth += return_this_shit.1
        
        ret.last_view_for_auto_layout = last_view
        
        return ret
    }
    
    func NPCD_create_card_detail_build_single(type: card_detail_type, body: String, vfsl: [String]) -> (UIView, CGFloat) {
        let ret = UIView()
        var lenth = CGFloat(2)
        
        switch type {
        case .text:
            do {
                let text_view = UITextView()
                let font = UIFont(name: ".SFUIText-Semibold", size: 16) ?? UIFont.systemFont(ofSize: 16)
                text_view.font = font
                text_view.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
                text_view.text = body
                text_view.backgroundColor = .clear
                text_view.isUserInteractionEnabled = false
                ret.addSubview(text_view)
                
                text_view.snp.makeConstraints { (x) in
                    x.left.equalTo(ret.snp.left)
                    x.right.equalTo(ret.snp.right)
                    x.top.equalTo(ret.snp.top)
                    if LKRoot.is_iPad {
                        // 晚点再来处理
                        x.height.equalTo(text_view.sizeThatFits(CGSize(width: 444, height: CGFloat.infinity)).height)
                        lenth += text_view.sizeThatFits(CGSize(width: 444, height: CGFloat.infinity)).height
                    } else {
                        x.height.equalTo(text_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 56, height: CGFloat.infinity)).height)
                        lenth += text_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 56, height: CGFloat.infinity)).height
                    }
                }
            }
        case .text_inherit_saying:
            do {
                lenth = 28
                let left_label = UILabel()
                left_label.text = "“"
                left_label.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
                left_label.font = UIFont(name:"HiraMinProN-W6", size: 128)
                ret.addSubview(left_label)
                left_label.snp.makeConstraints { (x) in
                    x.top.equalTo(ret.snp.top).offset(-35)
                    x.left.equalTo(ret.snp.left).offset(-15)
                    x.width.equalTo(150)
                    x.height.equalTo(188)
                }
                let text = UITextView()
                text.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
                text.text = body
                text.backgroundColor = .clear
                text.isUserInteractionEnabled = false
                text.font = .boldSystemFont(ofSize: 20)
                ret.addSubview(text)
                text.snp.makeConstraints { (x) in
                    x.left.equalTo(ret.snp.left).offset(55)
                    x.top.equalTo(ret.snp.top).offset(3)
                    x.right.equalTo(ret.snp.right).offset(0)
                    if LKRoot.is_iPad {
                        // 晚点再来处理
                        x.height.equalTo(text.sizeThatFits(CGSize(width: 444, height: CGFloat.infinity)).height)
                        lenth += text.sizeThatFits(CGSize(width: 444, height: CGFloat.infinity)).height
                    } else {
                        x.height.equalTo(text.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 56, height: CGFloat.infinity)).height) // 56 + 28
                        lenth += text.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 84, height: CGFloat.infinity)).height
                    }
                }
                let right_label = UILabel()
                right_label.text = "”"
                right_label.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
                right_label.font = UIFont(name:"HiraMinProN-W6", size: 54)
                ret.addSubview(right_label)
                right_label.snp.makeConstraints { (x) in
                    x.top.equalTo(text.snp.bottom).offset(-3)
                    x.right.equalTo(ret.snp.right).offset(12)
                    x.width.equalTo(55)
                    x.height.equalTo(55)
                }
                let des_str = UILabel()
                des_str.text = vfsl.first ?? ""
                des_str.font = UIFont(name:"Georgia-Blod", size: 16)
                des_str.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
                des_str.textAlignment = .right
                ret.addSubview(des_str)
                des_str.snp.makeConstraints { (x) in
                    x.top.equalTo(text.snp.bottom).offset(3)
                    x.right.equalTo(right_label.snp.left).offset(-4)
                    x.left.equalTo(ret.snp.left)
                    x.height.equalTo(18)
                }
            }
        case .photo:
            do {
                lenth = 166
                let image = UIImageView()
                ret.addSubview(image)
                image.sd_setImage(with: URL(string: vfsl.first ?? ""), placeholderImage: UIImage(named: "SDWebImagePlaceHolder"))
                image.contentMode = .scaleAspectFill
                image.clipsToBounds = true
                image.snp.makeConstraints { (x) in
                    x.top.equalTo(ret.snp.top)
                    x.left.equalTo(ret.snp.left).offset(8)
                    x.right.equalTo(ret.snp.right).offset(-8)
                    x.height.equalTo(166)
                }
            }
        case .photo_with_description:
            do {
                lenth = 200
                let image = UIImageView()
                ret.addSubview(image)
                image.sd_setImage(with: URL(string: vfsl.first ?? ""), placeholderImage: UIImage(named: "SDWebImagePlaceHolder"))
                image.contentMode = .scaleAspectFill
                image.clipsToBounds = true
                image.snp.makeConstraints { (x) in
                    x.top.equalTo(ret.snp.top)
                    x.left.equalTo(ret.snp.left).offset(8)
                    x.right.equalTo(ret.snp.right).offset(-8)
                    x.height.equalTo(166)
                }
                let des_str = UILabel()
                des_str.text = body
                des_str.font = UIFont(name:"HiraMinProN-W6", size: 12)
                des_str.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
                des_str.textAlignment = .center
                ret.addSubview(des_str)
                des_str.snp.makeConstraints { (x) in
                    x.top.equalTo(image.snp.bottom).offset(8)
                    x.left.equalTo(ret.snp.left).offset(8)
                    x.right.equalTo(ret.snp.right).offset(-8)
                    x.height.equalTo(34)
                }
            }
        default:
            print("[*] 这啥玩意啊？？？")
        }
        
        return (ret, lenth)
    } // NPCD_create_card_detail_build_single
}
