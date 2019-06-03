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
        
        ret.last_view_for_auto_layout = last_view
        
        return ret
    }
    
    func NPCD_create_card_detail_build_single(type: card_detail_type, body: String, vfsl: [String]) -> (UIView, CGFloat) {
        let ret = UIView()
        var lenth = CGFloat(0)
        
        switch type {
        case .text:
            do {
                let text_view = UITextView()
                let font = UIFont(name: ".SFUIText-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18)
                text_view.font = font
                text_view.textColor = .darkGray
                text_view.text = body
                text_view.isUserInteractionEnabled = false
                ret.addSubview(text_view)
                
                text_view.snp.makeConstraints { (x) in
                    x.left.equalTo(ret.snp.left)
                    x.right.equalTo(ret.snp.right)
                    x.top.equalTo(ret.snp.top)
                    if LKRoot.is_iPad {
                        // 晚点再来处理
                        x.height.equalTo(text_view.contentSize.height)
                    } else {
                        x.height.equalTo(text_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 56, height: CGFloat.infinity)).height)
                    }
                }
                lenth += text_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 56, height: CGFloat.infinity)).height
            }
        case .text_inherit_saying:
            do {
                lenth = 104
                
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
                des_str.font = UIFont(name:"Source Han Serif CN", size: 12)
                des_str.textColor = .lightGray
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
