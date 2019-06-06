//
//  UIManageS.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIManageS: UIViewController {
    
    var container: UIScrollView?
    var header_view: UIView?
    
    // 控制 NAV
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 先放一个 scrollview 放，且谨放一次
        if container == nil {
            container = UIScrollView()
            container?.tag = view_tags.main_scroll_view_in_view_controller.rawValue
            view.addSubview(container!)
        }
        
        // 处理一下头条
        let header = LKRoot.ins_view_manager.create_AS_home_header_view(title_str: "管理中心".localized(),
                                                                        sub_str: "在这里，你和你的全部".localized(),
                                                                        image_str: "NAMED:AccountHeadIconPlaceHolder")
        container!.addSubview(header)
        header_view = header
        
        // 为所有不可删除 view 打 tag
        for item in view.subviews {
            item.tag = view_tags.must_have.rawValue
        }
        
        // 处理 AutoLayout
        self.container?.snp.makeConstraints({ (x) in
            x.top.equalTo(self.view.safeAreaInsets.top)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.bottom.equalTo(self.view.safeAreaInsets.bottom)
        })
        header.snp.makeConstraints({ (x) in
            x.top.equalTo(self.container!.snp.top)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(100)
        })
        
        let test = LKIconGroupDetailView()
        test.apart_init(title: "新闻源".localized(),
                        sub_title: "这里包含了您在首页看到的所有新闻的来源。我们始终建议您只添加受信任的来源。".localized(),
                        title_color: LKRoot.ins_color_manager.read_a_color("main_title_two"),
                        sub_title_color: LKRoot.ins_color_manager.read_a_color("sub_text"))
        container?.addSubview(test)
        test.snp.makeConstraints { (x) in
            x.top.equalTo(self.header_view?.snp.bottom ?? self.view.snp.bottom).offset(28)
            x.left.equalTo(self.view.snp.left).offset(28)
            x.right.equalTo(self.view.snp.right).offset(-28)
            x.height.equalTo(test.lenth)
        }
        
    }
    
}
