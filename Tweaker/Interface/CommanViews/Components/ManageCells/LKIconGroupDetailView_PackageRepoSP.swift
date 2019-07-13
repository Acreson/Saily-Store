//
//  LKIconGroupDetailView_PackageRepoSP.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/11.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension manage_views {
    
    class LKIconGroupDetailView_PackageRepoSP: UIView, UITableViewDataSource {
        
        var is_collapsed = true
        let contentView = UIView()
        let table_view_container = UIView()
        
        var from_father_view: UIView?
        
        let expend_button = UIButton()
        let collapse_button = UIButton()
        let table_view = UITableView()
        let icon_stack = common_views.LKIconStack()
        
        var sync_news_repos = [DMNewsRepo]()
        
        init() {
            super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            table_view.register(cell_views.LKIconTVCell.self, forCellReuseIdentifier: "LKIconGroupDetailView_PackageRepoSP_TVID")
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func apart_init(father: UIView?) {
            
            LKRoot.container_manage_cell_status["PackageRepo"] = is_collapsed
            
            let RN_ANCHOR_O = 24
            let RN_ANCHOR_I = 16
            
            if father != nil {
                from_father_view = father!
            }
            
            sync_news_repos = LKRoot.container_news_repo
            
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
            title_view.text = "软件源".localized()
            title_view.textColor = LKRoot.ins_color_manager.read_a_color("main_title_one")
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
            sub_title_view.text = "这里包含了您在系统中所使用的所有软件包的来源。我们强烈建议您只添加受信任的来源。不被信任的来源通常包含病毒或者过期的、不支持当前系统的软件包。这可能会损坏您的设备。".localized()
            sub_title_view.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
            sub_title_view.font = .systemFont(ofSize: 10)
            sub_title_view.isUserInteractionEnabled = false
            sub_title_view.backgroundColor = .clear
            contentView.addSubview(sub_title_view)
            sub_title_view.snp.makeConstraints { (x) in
                x.top.equalTo(title_view.snp.bottom).offset(-4)
                x.left.equalTo(self.contentView.snp.left).offset(RN_ANCHOR_I - 4)
                x.right.equalTo(self.contentView.snp.right).offset(-RN_ANCHOR_I + 4)
//                x.height.equalTo(sub_title_view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 92, height: .infinity)))
                x.height.equalTo(47)
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
            var icon_addrs = [String]()
//            for item in sync_news_repos {
//                icon_addrs.append(item.icon)
//            }
            icon_stack.images_address = icon_addrs
            icon_stack.apart_init()
            contentView.addSubview(icon_stack)
            icon_stack.snp.makeConstraints { (x) in
                x.right.equalTo(self.contentView.snp.right).offset(RN_ANCHOR_I)
                x.top.equalTo(self.contentView.snp.top).offset(12)
                x.width.equalTo(2)
                x.height.equalTo(33)
            }
            
            contentView.addSubview(table_view_container)
            table_view_container.clipsToBounds = true
            table_view_container.snp.makeConstraints { (x) in
                x.top.equalTo(sep.snp.bottom).offset(18)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.bottom.equalTo(contentView.snp.bottom).offset(-8)
            }
            
            // 展开按钮
            expend_button.setTitle("点击来展开全部新闻源 ▼".localized(), for: .normal)
            expend_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_one"), for: .normal)
            expend_button.setTitleColor(.gray, for: .highlighted)
            contentView.addSubview(expend_button)
            expend_button.snp.remakeConstraints { (x) in
                //            x.bottom.equalTo(self.contentView.snp.bottom)
                x.height.equalTo(30)
                x.top.equalTo(sep.snp.bottom).offset(2)
                x.left.equalTo(self.contentView.snp.left)
                x.right.equalTo(self.contentView.snp.right)
            }
            
            // 关闭按钮
            collapse_button.setTitle("收起 ▲".localized(), for: .normal)
            collapse_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            collapse_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_one"), for: .normal)
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
            table_view.isScrollEnabled = false
            table_view_container.addSubview(table_view)
            table_view.snp.makeConstraints { (x) in
                x.top.equalTo(self.table_view_container.snp.top)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.height.equalTo(LKRoot.container_news_repo.count * 62)
            }
            table_view.separatorColor = .clear
            table_view.backgroundColor = .clear
            table_view.beginUpdates()
            table_view.reloadData()
            table_view.endUpdates()
            
            expend_button.addTarget(self, action: #selector(expend_self), for: .touchUpInside)
            collapse_button.addTarget(self, action: #selector(collapse_self), for: .touchUpInside)
            
            if sync_news_repos.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.expend_self()
                }
            }
            
        }
        
        func update_status() {
            LKRoot.container_manage_cell_status["NewsRepo"] = is_collapsed
        }
        
        @objc func expend_self() {

        }
        
        @objc func collapse_self() {
        
        }
    }
    
}

extension manage_views.LKIconGroupDetailView_PackageRepoSP: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= sync_news_repos.count {
            let ret = cell_views.LK2ButtonStackTVCell()
            ret.button1.setTitle("添加".localized(), for: .normal)
            ret.button2.setTitle("分享".localized(), for: .normal)
            ret.button1.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_one"), for: .normal)
            ret.button2.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_one"), for: .normal)
            ret.button1.addTarget(self, action: #selector(add_button_recall), for: .touchUpInside)
            ret.button2.addTarget(self, action: #selector(share_button_recall), for: .touchUpInside)
            ret.backgroundColor = .clear
            return ret
        }
        let ret = tableView.dequeueReusableCell(withIdentifier: "LKIconGroupDetailView_PackageRepoSP_TVID", for: indexPath) as? cell_views.LKIconTVCell ?? cell_views.LKIconTVCell()

        return ret
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= sync_news_repos.count {
            return 43
        }
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row < sync_news_repos.count {
            touched_cell(which: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < sync_news_repos.count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "分享".localized()) { _, index in
        }
        share.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_title_one")
        
        let delete = UITableViewRowAction(style: .normal, title: "删除") { _, index in
        }
        delete.backgroundColor = .red
        return [share, delete]
    }
    
    func update_user_interface(CallB: @escaping () -> Void) {
        
    }
    
    @objc func add_button_recall(sender: Any?) {
        
    }
    
    @objc func share_button_recall(sender: Any?) {
        
    }
    
    func touched_cell(which: IndexPath) {
        
    }
    
}

