//
//  LKIconGroupDetailView_RecentUpdate.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension manage_views {
    
    class LKIconGroupDetailView_RecentUpdate: UIView, UITableViewDataSource {
        
        var initd = false
        
        var is_collapsed = true
        let contentView = UIView()
        let table_view_container = UIView()
        
        var from_father_view: UIView?
        
        let expend_button = UIButton()
        let collapse_button = UIButton()
        let table_view = UITableView()
        let icon_stack = common_views.LKIconStack()
        
        init() {
            super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            table_view.register(cell_views.LKIconTVCell.self, forCellReuseIdentifier: "LKIconGroupDetailView_RecentUpdate_TVID")
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func apart_init(father: UIView?) {
            
            initd = true
            
            LKRoot.container_manage_cell_status["RU_IS_COLLAPSED"] = is_collapsed
            
            let RN_ANCHOR_O = 24
            let RN_ANCHOR_I = 16
            
            if father != nil {
                from_father_view = father!
            }
            
            contentView.setRadiusINT(radius: LKRoot.settings?.card_radius)
            contentView.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_back_ground")
            contentView.addShadow(ofColor: LKRoot.ins_color_manager.read_a_color("shadow"))
            addSubview(contentView)
            contentView.snp.makeConstraints { (x) in
                x.top.equalTo(self.snp.top).offset(RN_ANCHOR_O - 8)
                x.bottom.equalTo(self.snp.bottom).offset(-RN_ANCHOR_O + 8)
                x.left.equalTo(self.snp.left).offset(RN_ANCHOR_O)
                x.right.equalTo(self.snp.right).offset(-RN_ANCHOR_O)
            }
            
            // 标题
            let title_view = UILabel()
            title_view.text = "最近更新".localized()
            title_view.textColor = LKRoot.ins_color_manager.read_a_color("main_title_four")
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
            sub_title_view.text = "这个板块显示了最近更新的软件包。".localized()
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
                x.height.equalTo(33)
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
            
//            // 图标组
//            re_sync()
//            if LKRoot.container_string_store["REFRESH_IN_POGRESS_PR"] == "FALSE" {
//                var icon_addrs = [String]()
//                for item in LKRoot.container_package_repo_DBSync {
//                    icon_addrs.append(item.icon)
//                }
//                icon_stack.images_address = icon_addrs
//            }
//            icon_stack.apart_init()
//            contentView.addSubview(icon_stack)
//            icon_stack.snp.makeConstraints { (x) in
//                x.right.equalTo(self.contentView.snp.right).offset(RN_ANCHOR_I)
//                x.top.equalTo(self.contentView.snp.top).offset(12)
//                x.width.equalTo(2)
//                x.height.equalTo(33)
//            }
            
            contentView.addSubview(table_view_container)
            table_view_container.clipsToBounds = true
            table_view_container.snp.makeConstraints { (x) in
                x.top.equalTo(sep.snp.bottom).offset(18)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.bottom.equalTo(contentView.snp.bottom).offset(-8)
            }
            
            // 展开按钮
            expend_button.setTitle("点击来展开最近更新 ▼".localized(), for: .normal)
            expend_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_four"), for: .normal)
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
            collapse_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_four"), for: .normal)
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
            
            if LKRoot.container_recent_update.count != 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.expend_self()
                }
            }
            
        }
        
        func re_sync() {
            guard let pack: [DBMPackage] = try? LKRoot.root_db?.getObjects(fromTable: common_data_handler.table_name.LKPackages.rawValue,
                                                                           orderBy: [DBMPackage.Properties.latest_update_time.asOrder(by: .descending),
                                                                                     DBMPackage.Properties.one_of_the_package_name_lol.asOrder(by: .ascending),
                                                                                     DBMPackage.Properties.id.asOrder(by: .ascending)],
                                                                           limit: 128) else {
                                                                            print("[E] 无法从 LKPackages 中获得数据，终止同步。")
                                                                            return
            }
            LKRoot.container_recent_update = pack
        }
        
        func update_status() {
            LKRoot.container_manage_cell_status["RU_IS_COLLAPSED"] = is_collapsed
        }
        
        @objc func expend_self() {
            if !is_collapsed {
                return
            }
            re_sync()
            if LKRoot.container_recent_update.count < 1 {
                UIView.transition(with: expend_button, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.expend_button.setTitle("没有最近更新的软件包".localized(), for: .normal)
                    self.expend_button.setTitleColor(.red, for: .normal)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.transition(with: self.expend_button, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.expend_button.setTitle("点击来展开最近更新 ▼".localized(), for: .normal)
                        self.expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_two"), for: .normal)
                    })
                }
                return
            }
            is_collapsed = false
            table_view.reloadData()
            table_view.snp.remakeConstraints { (x) in
                x.top.equalTo(self.table_view_container.snp.top)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                var count = LKRoot.container_recent_update.count
                if count > 12 {
                    count = 12
                }
                x.height.equalTo(count * 62 + 5)
            }
            update_status()
            // 起始状态
            collapse_button.alpha = 0
            collapse_button.isHidden = false
            table_view.alpha = 0
            table_view.isHidden = false
            UIApplication.shared.beginIgnoringInteractionEvents()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            DispatchQueue.main.async {
                (self.from_father_view as? UITableView)?.beginUpdates()
                LKRoot.container_string_store["in_progress_UI_manage_update"] = "TRUE"
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    (self.from_father_view as? UITableView)?.endUpdates()
                    self.expend_button.alpha = 0
                    self.collapse_button.alpha = 1
                    self.icon_stack.alpha = 0
                    self.table_view.alpha = 1
                }, completion: { (_) in
                    LKRoot.container_string_store["in_progress_UI_manage_update"] = "FALSE"
                    self.expend_button.isHidden = true
                    self.icon_stack.isHidden = true
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
            }
        }
        
        @objc func collapse_self() {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            if is_collapsed {
                update_status()
                return
            }
            is_collapsed = true
            update_status()
            // 起始状态
            expend_button.alpha = 0
            expend_button.isHidden = false
            icon_stack.alpha = 0
            icon_stack.isHidden = false
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.async {
                (self.from_father_view as? UITableView)?.beginUpdates()
                LKRoot.container_string_store["in_progress_UI_manage_update"] = "TRUE"
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    (self.from_father_view as? UITableView)?.endUpdates()
                    self.collapse_button.alpha = 0
                    self.expend_button.alpha = 1
                    self.icon_stack.alpha = 1
                    self.table_view.alpha = 0
                }, completion: { (_) in
                    LKRoot.container_string_store["in_progress_UI_manage_update"] = "FALSE"
                    self.collapse_button.isHidden = true
                    self.table_view.isHidden = true
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
            }
        }
    }
    
}

extension manage_views.LKIconGroupDetailView_RecentUpdate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var c = LKRoot.container_recent_update.count
        if c > 12 {
            c = 12
        }
        return c
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = tableView.dequeueReusableCell(withIdentifier: "LKIconGroupDetailView_RecentUpdate_TVID", for: indexPath) as? cell_views.LKIconTVCell ?? cell_views.LKIconTVCell()
        let pack = LKRoot.container_recent_update[indexPath.row]
        let version = LKRoot.ins_common_operator.PAK_read_newest_version(pack: pack)
        ret.title.text = LKRoot.ins_common_operator.PAK_read_name(pack: pack, version: version)
        ret.link.text = LKRoot.ins_common_operator.PAK_read_description(pack: pack, version: version)
        let icon_link = LKRoot.ins_common_operator.PAK_read_icon_addr(pack: pack, version: version)
        if icon_link.hasPrefix("http") {
            ret.icon.sd_setImage(with: URL(string: icon_link), placeholderImage: UIImage(named: "Gary")) { (img, err, _, _) in
                if err != nil || img == nil {
                    ret.icon.image = UIImage(named: "Error")
                }
            }
        } else if icon_link.hasPrefix("NAMED:") {
            let link = icon_link.dropFirst("NAMED:".count).to_String()
            ret.icon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: "Gary")) { (img, err, _, _) in
                if err != nil || img == nil {
                    ret.icon.image = UIImage(named: "Error")
                }
            }
        } else {
            if let some = UIImage(contentsOfFile: icon_link) {
                ret.icon.image = some
            } else {
                ret.icon.image = UIImage(named: "ATCydiaSource")
            }
        }
        ret.backgroundColor = .clear
        return ret
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row < LKRoot.container_package_repo_DBSync.count {
            touched_cell(which: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "分享".localized()) { _, index in
            LKRoot.container_recent_update[index.row].id.pushClipBoard()
            presentStatusAlert(imgName: "Done",
                               title: "成功".localized(),
                               msg: "这个软件包的名字已经复制到剪贴板".localized())
        }
        share.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_title_four")
        
        return [share]
    }
    
    func touched_cell(which: IndexPath) {
        
    }
    
}


