//
//  UIMineS.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/17.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIMineS: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_background")
        
        let coming = UIImageView(image: UIImage(named: "commingSoon"))
        view.addSubview(coming)
        coming.snp.makeConstraints { (x) in
            x.center.equalTo(self.view.snp.center)
            x.width.equalTo(128)
            x.height.equalTo(128)
        }
        
    }
    
}
