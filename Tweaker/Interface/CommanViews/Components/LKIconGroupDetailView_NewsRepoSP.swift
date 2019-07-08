//
//  LKIconGroupDetailView_NewsRepoSP.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/8.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class LKIconGroupDetailView_NewsRepoSP: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var is_collapsed = true
    let contentView = UIView()
    
    var from_father_view: UIView?
    
    let expend_button = UIButton()
    let collapse_button = UIButton()
    let table_view = UITableView()
    
    func apart_init(father: UIView?) {
        
        let RN_ANCHOR_O = 24
        let RN_ANCHOR_I = 16
        
        if father != nil {
            from_father_view = father!
        }
        
        self.is_collapsed = LKRoot.settings?.manage_tab_news_repo_is_collapsed ?? true
        contentView.setRadiusINT(radius: LKRoot.settings?.card_radius)
        contentView.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_back_ground")
        contentView.addShadow(ofColor: LKRoot.ins_color_manager.read_a_color("shadow"))
        addSubview(contentView)
        contentView.snp.makeConstraints { (x) in
            x.top.equalTo(self.snp.top).offset(RN_ANCHOR_O)
            x.bottom.equalTo(self.snp.bottom).offset(-RN_ANCHOR_O)
            x.left.equalTo(self.snp.left).offset(RN_ANCHOR_O)
            x.right.equalTo(self.snp.right).offset(-RN_ANCHOR_O)
        }
        
        // 标题
        let title_view = UILabel()
        title_view.text = "新闻源".localized()
        title_view.textColor = LKRoot.ins_color_manager.read_a_color("main_title_two")
        title_view.font = .boldSystemFont(ofSize: 28)
        contentView.addSubview(title_view)
        title_view.snp.makeConstraints { (x) in
            x.top.equalTo(self.contentView.snp.top).offset(6)
            x.left.equalTo(self.contentView.snp.left).offset(RN_ANCHOR_I)
            x.height.equalTo(46)
            x.width.equalTo(188)
        }
        
        // 描述
        let sub_title_view = UITextView()
        sub_title_view.text = "这里包含了您在首页看到的所有新闻的来源。我们始终建议您只添加受信任的来源。"
        sub_title_view.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
        sub_title_view.font = .systemFont(ofSize: 10)
        sub_title_view.isUserInteractionEnabled = false
        contentView.addSubview(sub_title_view)
        sub_title_view.snp.makeConstraints { (x) in
            x.top.equalTo(title_view.snp.bottom).offset(0)
            x.left.equalTo(self.contentView.snp.left).offset(RN_ANCHOR_I - 4)
            x.right.equalTo(self.contentView.snp.right).offset(-RN_ANCHOR_I + 4)
            x.height.equalTo(sub_title_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 92, height: .infinity)))
        }
        
        // 分割线
        let sep = UIView()
        sep.backgroundColor = LKRoot.ins_color_manager.read_a_color("tabbar_untint")
        sep.alpha = 0.3
        contentView.addSubview(sep)
        sep.snp.makeConstraints { (x) in
            x.top.equalTo(sub_title_view.snp.bottom).offset(6)
            x.left.equalTo(self.contentView.snp.left)
            x.right.equalTo(self.contentView.snp.right)
            x.height.equalTo(0.5)
        }
        
        // 图标组
        let icon_stack = LKIconStack()
        var icon_addrs = [String]()
        for item in LKRoot.container_news_repo {
            icon_addrs.append(item.icon)
        }
        icon_stack.images_address = icon_addrs
        icon_stack.apart_init()
        contentView.addSubview(icon_stack)
        icon_stack.snp.makeConstraints { (x) in
            x.right.equalTo(self.contentView.snp.right).offset(RN_ANCHOR_I)
            x.top.equalTo(self.contentView.snp.top).offset(12)
            x.width.equalTo(2)
            x.height.equalTo(33)
        }
        
        // 展开按钮
        expend_button.setTitle("点击来展开全部新闻源 ▼".localized(), for: .normal)
        expend_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_two"), for: .normal)
        expend_button.setTitleColor(.gray, for: .highlighted)
        contentView.addSubview(expend_button)
        expend_button.snp.remakeConstraints { (x) in
            x.bottom.equalTo(self.contentView.snp.bottom)
            x.top.equalTo(sep.snp.bottom)
            x.left.equalTo(self.contentView.snp.left)
            x.right.equalTo(self.contentView.snp.right)
        }
        
        // 关闭按钮
        collapse_button.setTitle("收起 ▲".localized(), for: .normal)
        collapse_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        collapse_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_two"), for: .normal)
        collapse_button.setTitleColor(.gray, for: .highlighted)
        collapse_button.isHidden = true
        contentView.addSubview(collapse_button)
        collapse_button.snp.makeConstraints { (x) in
            x.centerY.equalTo(title_view.snp.centerY)
            x.right.equalTo(self.contentView.snp.right).offset(-RN_ANCHOR_I)
        }
        
        collapse_button.bringSubviewToFront(contentView)
        contentView.bringSubviewToFront(self)
        
        table_view.delegate = self
        table_view.dataSource = self
        table_view.isHidden = true
        contentView.addSubview(table_view)
        table_view.snp.makeConstraints { (x) in
            x.top.equalTo(sep.snp.bottom).offset(12)
            x.left.equalTo(contentView.snp.left).offset(8)
            x.right.equalTo(contentView.snp.right).offset(-8)
            x.height.equalTo(LKRoot.container_news_repo.count * 62)
        }
        table_view.beginUpdates()
        table_view.reloadData()
        table_view.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LKRoot.container_news_repo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
