//
//  UIHommy.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIHommyS: UIViewController {
    
    var container: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 先放一个 scrollview 放，且谨放一次
        if container == nil {
            container = UIScrollView()
            view.addSubview(container!)
        }
        
        // 处理一下头条
        let header = LKRoot.ins_view_manager.create_AS_home_header_view()
        container!.addSubview(header)
        // 处理 AutoLayout
        
        DispatchQueue.main.async {
            self.container?.snp.makeConstraints({ (x) in
                x.top.equalTo(self.view.safeAreaInsets.top)
                x.left.equalTo(self.view.snp.left)
                x.right.equalTo(self.view.snp.right)
                x.bottom.equalTo(self.view.safeAreaInsets.bottom)
            })
            header.snp.makeConstraints { (x) in
                x.top.equalTo(self.container!.snp.top)
                x.left.equalTo(self.view.snp.left)
                x.right.equalTo(self.view.snp.right)
                x.height.equalTo(66)
            }
        }
    }
    
}
