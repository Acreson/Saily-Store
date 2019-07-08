//
//  LKIconStack.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/8.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class LKIconStack: UIView {
    
    var image_views = [UIImageView]()
    var images_address = [String]()
    
    private var last_image_address = [String]()
    
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
        
        if last_image_address == images_address {
            return
        }
        
        last_image_address = images_address
        
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
