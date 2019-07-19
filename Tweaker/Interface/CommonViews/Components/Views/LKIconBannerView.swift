//
//  LKIconBannerView.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/18.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension common_views {
    
    class LKIconBannerView: UIView {
        
        public let icon = UIImageView()
        public let title = UILabel()
        public let sub_title = UILabel()
        public let button = UIButton()
        
        func apart_init() {
            addSubview(icon)
            addSubview(title)
            addSubview(sub_title)
            addSubview(button)
            
            icon.setRadiusINT(radius: 12)
            icon.snp.makeConstraints { (x) in
                x.centerY.equalTo(self.snp.centerY)
                x.left.equalTo(self.snp.left).offset(18)
                x.width.equalTo(55)
                x.height.equalTo(55)
            }
            
            button.titleLabel?.font = .boldSystemFont(ofSize: 16)
            button.setRadiusCGF(radius: 15)
            button.snp.makeConstraints { (x) in
                x.centerY.equalTo(self.snp.centerY)
                x.right.equalTo(self.snp.right).offset(-18)
                x.width.equalTo(66)
                x.height.equalTo(30)
            }
            
            title.font = .boldSystemFont(ofSize: 22)
            title.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
            title.snp.makeConstraints { (x) in
                x.left.equalTo(icon.snp.right).offset(18)
                x.right.equalTo(button.snp.left).offset(-18)
                x.top.equalTo(icon.snp.top).offset(4)
                x.height.equalTo(24)
            }
            
            sub_title.font = .boldSystemFont(ofSize: 16)
            sub_title.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
            sub_title.snp.makeConstraints { (x) in
                x.top.equalTo(title.snp.bottom).offset(4)
                x.left.equalTo(icon.snp.right).offset(18)
                x.right.equalTo(button.snp.left).offset(-18)
                x.bottom.equalTo(icon.snp.bottom)
            }
            
        }
        
    }
    
}
