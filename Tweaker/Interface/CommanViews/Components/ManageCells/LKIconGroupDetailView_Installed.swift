//
//  LKIconGroupDetailView_Installed.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension manage_views {
    
    class LKIconGroupDetailView_Installed: UIView, UITableViewDataSource {
        
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
            table_view.register(cell_views.LKIconTVCell.self, forCellReuseIdentifier: "LKIconGroupDetailView_Installed_TVID")
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func apart_init(father: UIView?) {
            
            initd = true
            
            LKRoot.container_manage_cell_status["YA_IS_COLLAPSED"] = is_collapsed
            
            let RN_ANCHOR_O = 24
            let RN_ANCHOR_I = 16
            
            if father != nil {
                from_father_view = father!
            }
            
            re_sync()
            
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
            title_view.text = "已安装".localized()
            title_view.textColor = LKRoot.ins_color_manager.read_a_color("main_operations_allow")
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
            sub_title_view.text = "这里包含了您在系统中已经安装的软件包。".localized()
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
            
            // 图标组

            icon_stack.images_address = ["ATCydiaSource"]
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
            expend_button.setTitle("点击来展开一些最近的安装 ▼".localized(), for: .normal)
            expend_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_operations_allow"), for: .normal)
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
            collapse_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_operations_allow"), for: .normal)
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
            
        }
        
        func re_sync() {
            
        }
        
        func update_status() {
            LKRoot.container_manage_cell_status["YA_IS_COLLAPSED"] = is_collapsed
        }
        
        @objc func expend_self() {
            
            re_sync()
            table_view.reloadData()
            table_view.snp.remakeConstraints { (x) in
                x.top.equalTo(self.table_view_container.snp.top)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
//                x.height.equalTo((LKRoot.---.count + 1) * 62 + 5 - 32)
                x.height.equalTo(108)
            }

            if !is_collapsed {
                update_status()
                return
            }
            is_collapsed = false
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

extension manage_views.LKIconGroupDetailView_Installed: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return LKRoot.---.count + 1
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row >= LKRoot.---.count {
//            let ret = cell_views.LK2ButtonStackTVCell()
//            ret.button1.setTitle("整理导出".localized(), for: .normal)
//            ret.button2.setTitle("查看全部".localized(), for: .normal)
//            ret.button1.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_operations_allow"), for: .normal)
//            ret.button2.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_operations_allow"), for: .normal)
//            ret.button1.addTarget(self, action: #selector(export_button_recall(sender:)), for: .touchUpInside)
//            ret.button2.addTarget(self, action: #selector(share_button_recall), for: .touchUpInside)
//            ret.backgroundColor = .clear
//            return ret
//        }
        let ret = tableView.dequeueReusableCell(withIdentifier: "LKIconGroupDetailView_Installed_TVID", for: indexPath) as? cell_views.LKIconTVCell ?? cell_views.LKIconTVCell()
//        ret.icon.sd_setImage(with: URL(string: LKRoot.---[indexPath.row].icon), placeholderImage: UIImage(named: "Gary")) { (img, err, _, _) in
//            if err != nil || img == nil {
//                if let image = UIImage(named: LKRoot.---[indexPath.row].icon) {
//                    ret.icon.image = image
//                } else {
//                    ret.icon.image = UIImage(named: "AppIcon")
//                }
//            }
//        }
//        ret.title.text = LKRoot.---[indexPath.row].name
//        ret.link.text = LKRoot.---[indexPath.row].link
        ret.backgroundColor = .clear
        return ret
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row >= LKRoot.---.count {
//            return 43
//        }
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
//        if indexPath.row < LKRoot.---.count {
//            touched_cell(which: indexPath)
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row < LKRoot.---.count {
//            return true
//        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "分享".localized()) { _, index in
//            LKRoot.---[index.row].link.pushClipBoard()
//            presentStatusAlert(imgName: "Done",
//                               title: "成功".localized(),
//                               msg: (LKRoot.---[index.row].name) + " 的地址已经复制到剪贴板".localized())
        }
        share.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_operations_allow")
        
        let delete = UITableViewRowAction(style: .normal, title: "卸载".localized()) { _, index in
        }
        delete.backgroundColor = .red
        return [share, delete]
    }
    
    func update_user_interface(_ CallB: @escaping () -> Void) {
        // 刷新成功了 先展开表格，再更新iconStack，最后reload自己
        self.re_sync()
        DispatchQueue.main.async {
            (self.from_father_view as? UITableView)?.beginUpdates()
            LKRoot.container_string_store["in_progress_UI_manage_update"] = "TRUE"
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                (self.from_father_view as? UITableView)?.endUpdates()
            }, completion: { (_) in
                LKRoot.container_string_store["in_progress_UI_manage_update"] = "FALSE"
                self.table_view.snp.remakeConstraints { (x) in
                    x.top.equalTo(self.table_view_container.snp.top)
                    x.left.equalTo(self.contentView.snp.left).offset(8)
                    x.right.equalTo(self.contentView.snp.right).offset(-8)
                    //                    x.height.equalTo((LKRoot.---.count + 1) * 62 + 5 - 32)
                    x.height.equalTo(108)
                }
                self.icon_stack.apart_init()
                self.table_view.reloadData()
                UIApplication.shared.endIgnoringInteractionEvents()
                IHProgressHUD.dismiss()
                CallB()
            })
        }
    }
    
    @objc func export_button_recall(sender: Any?) {
        
    }
    
    @objc func share_button_recall(sender: Any?) {
    }
    
    func touched_cell(which: IndexPath) {
        
    }
    
}

