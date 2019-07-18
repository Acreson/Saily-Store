//
//  LKSectionBeginHeader.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/18.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension common_views {
    
    class LKSectionBeginHeader: UIView {
        
        var theme_color: UIColor? = nil
        
        private let label = UILabel()
        private let line = UIView()
        
        func apart_init(section_name: String) {
            addSubview(label)
            addSubview(line)
            
            label.backgroundColor = theme_color ?? LKRoot.ins_color_manager.read_a_color("main_tint_color")
            label.textColor = .white
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 16)
            label.text = section_name.localized()
            label.setRadiusINT(radius: 2)
            label.snp.makeConstraints { (x) in
                x.left.equalTo(self.snp.left).offset(20.2)
                x.top.equalTo(self.snp.top)
                x.bottom.equalTo(self.snp.bottom)
                x.width.equalTo(188)
            }
            
            line.backgroundColor = theme_color ?? LKRoot.ins_color_manager.read_a_color("main_tint_color")
            line.snp.makeConstraints { (x) in
                x.left.equalTo(self.snp.left)
                x.bottom.equalTo(label.snp.bottom)
                x.right.equalTo(self.snp.right)
                x.height.equalTo(2)
            }
            
            
        }
        
    }
    
}
