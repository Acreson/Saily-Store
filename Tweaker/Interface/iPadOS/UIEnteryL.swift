//
//  UIEntery.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIEnteryL: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("[*] 将以 iPad 的方式加载故事版。")
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let view = item.value(forKey: "_view") as? UIView else { return   }
        for item in view.subviews {
            if let image = item as? UIImageView {
                image.shineAnimation()
                break
            }
        }
    }
    
}
