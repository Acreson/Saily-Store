//
//  UICardDetailView.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/6/3.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UICardDetailView: UIView {
    
    var lenth: CGFloat = 128
    
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
        
        
        
        return ret
    }
}
