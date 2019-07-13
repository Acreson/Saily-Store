//
//  LKActiveShineCell.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension manage_views {
    
    class LKActiveShineCell: UIView {
        
        let dark = UILabel()
        
        func apart_init() {
            dark.text = (LKRoot.container_string_store["STR_SIG_PROGRESS"]?.localized() ?? "")
                + (LKRoot.container_string_store["STR_SIG_PROGRESS_NUM"]?.localized() ?? "")
            dark.textAlignment = .center
            dark.font = .boldSystemFont(ofSize: 18)
            dark.textColor = LKRoot.ins_color_manager.read_a_color("main_operations_attention").darken(by: 0.01)
            dark.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            addSubview(dark)
            dark.snp.makeConstraints { (x) in
                x.edges.equalTo(self.snp.edges)
            }
            animation()
            
        }
        
        func animation() {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, animations: {
                    self.dark.alpha = 0.9
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.6, animations: {
                        self.dark.alpha = 1
                    }, completion: { (_) in
                        self.animation()
                    })
                })
            }
        }
        
        
    }
    
}
