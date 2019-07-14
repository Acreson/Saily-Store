//
//  LKIconGroupDetailView_PackageRepoSP.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/11.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension manage_views {
    
    // swiftlint:disable:next type_body_length
    class LKIconGroupDetailView_PackageRepoSP: UIView, UITableViewDataSource {
        
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
            table_view.register(cell_views.LKIconTVCell.self, forCellReuseIdentifier: "LKIconGroupDetailView_PackageRepoSP_TVID")
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func apart_init(father: UIView?) {
            
            LKRoot.container_manage_cell_status["PR_IS_COLLAPSED"] = is_collapsed
            
            let RN_ANCHOR_O = 24
            let RN_ANCHOR_I = 16
            
            if father != nil {
                from_father_view = father!
            }
            
            sync()
            
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
            re_sync()
            if LKRoot.container_string_store["REFRESH_IN_POGRESS_PR"] == "FALSE" {
                var icon_addrs = [String]()
                for item in LKRoot.container_package_repo_DBSync {
                    icon_addrs.append(item.icon)
                }
                icon_stack.images_address = icon_addrs
            }
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
            
            if LKRoot.container_package_repo_DBSync.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.expend_self()
                }
            }
            
        }
        
        func re_sync() {
            LKRoot.container_package_repo_DBSync = LKRoot.container_package_repo
            guard let repos: [DBMPackageRepos] = try? LKRoot.root_db?.getObjects(on: [DBMPackageRepos.Properties.link,
                                                                                      DBMPackageRepos.Properties.icon,
                                                                                      DBMPackageRepos.Properties.name,
                                                                                      DBMPackageRepos.Properties.sort_id],
                                                                                 fromTable: common_data_handler.table_name.LKPackageRepos.rawValue,
                                                                                 orderBy: [DBMPackageRepos.Properties.sort_id.asOrder(by: .ascending)]) else {
                                                                                    print("[E] 无法从 LKPackageRepos 中获得数据，终止同步。")
                                                                                    return
            } // guard let
            for item in repos {
                var exists = false
                inner: for exs in LKRoot.container_package_repo_DBSync where exs.link == item.link ?? "" {
                    exists = true
                    break inner
                }
                if !exists {
                    let new = DMPackageRepos()
                    new.link = item.link ?? ""
                    new.name = "未知错误".localized()
                    new.icon = "Error"
                    LKRoot.container_package_repo_DBSync.append(new)
                }
            }
        }
        
        func update_status() {
            LKRoot.container_manage_cell_status["PR_IS_COLLAPSED"] = is_collapsed
        }
        
        @objc func expend_self() {
            
            
            if LKRoot.container_string_store["REFRESH_IN_POGRESS_PR"] == "TRUE" {
                UIView.transition(with: expend_button, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.expend_button.setTitle("请等待首次刷新进程完成".localized(), for: .normal)
                    self.expend_button.setTitleColor(.red, for: .normal)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.transition(with: self.expend_button, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.expend_button.setTitle("点击来展开全部软件源 ▼".localized(), for: .normal)
                        self.expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_two"), for: .normal)
                    })
                }
                return
            }
            
            re_sync()
            table_view.reloadData()
            table_view.snp.remakeConstraints { (x) in
                x.top.equalTo(self.table_view_container.snp.top)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.height.equalTo((LKRoot.container_package_repo_DBSync.count + 1) * 62 + 5 - 32)
            }
            var icon_addrs = [String]()
            for item in LKRoot.container_package_repo_DBSync {
                icon_addrs.append(item.icon)
            }
            icon_stack.images_address = icon_addrs
            icon_stack.ever_inited = 1
            icon_stack.apart_init()
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

extension manage_views.LKIconGroupDetailView_PackageRepoSP: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LKRoot.container_package_repo_DBSync.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= LKRoot.container_package_repo_DBSync.count {
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
        ret.icon.sd_setImage(with: URL(string: LKRoot.container_package_repo_DBSync[indexPath.row].icon), placeholderImage: UIImage(named: "Gary")) { (img, err, _, _) in
            if err != nil || img == nil {
                if let image = UIImage(named: LKRoot.container_package_repo_DBSync[indexPath.row].icon) {
                    ret.icon.image = image
                } else {
                    ret.icon.image = UIImage(named: "AppIcon")
                }
            }
        }
        ret.title.text = LKRoot.container_package_repo_DBSync[indexPath.row].name
        ret.link.text = LKRoot.container_package_repo_DBSync[indexPath.row].link
        ret.backgroundColor = .clear
        return ret
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= LKRoot.container_package_repo_DBSync.count {
            return 43
        }
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row < LKRoot.container_package_repo_DBSync.count {
            touched_cell(which: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < LKRoot.container_package_repo_DBSync.count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "分享".localized()) { _, index in
            LKRoot.container_package_repo_DBSync[index.row].link.pushClipBoard()
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "Done")
            statusAlert.title = "成功".localized()
            statusAlert.message = (LKRoot.container_package_repo_DBSync[index.row].name) + "的地址已经复制到剪贴板".localized()
            statusAlert.canBePickedOrDismissed = true
            statusAlert.showInKeyWindow()
        }
        share.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_title_one")
        
        let delete = UITableViewRowAction(style: .normal, title: "删除") { _, index in
            self.re_sync()
            var out = [DBMPackageRepos]()
            var i = 0
            for item in LKRoot.container_package_repo_DBSync where item.link != LKRoot.container_package_repo_DBSync[index.row].link {
                let new = DBMPackageRepos()
                new.link = item.link
                new.sort_id = i
                out.append(new)
                i += 1
            }
            try? LKRoot.root_db?.delete(fromTable: common_data_handler.table_name.LKPackageRepos.rawValue,
                                        where: DBMPackageRepos.Properties.link == LKRoot.container_package_repo_DBSync[index.row].link)
            try? LKRoot.root_db?.insertOrReplace(objects: out, intoTable: common_data_handler.table_name.LKPackageRepos.rawValue)
            IHProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            LKRoot.queue_dispatch.async {
                LKRoot.ins_common_operator.PR_sync_and_download(sync_all: false) { (_)  in
                    self.update_user_interface {
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "Done")
                        statusAlert.title = "删除成功".localized()
                        statusAlert.message = "你已经成功的移除了这个软件源".localized()
                        statusAlert.canBePickedOrDismissed = true
                        statusAlert.showInKeyWindow()
                    }
                }
            }
        }
        delete.backgroundColor = .red
        return [share, delete]
    }
    
    func update_user_interface(_ CallB: @escaping () -> Void) {
        // 刷新成功了 先展开表格，再更新iconStack，最后reload自己
        self.re_sync()
        var icon_addrs = [String]()
        for item in LKRoot.container_package_repo_DBSync {
            icon_addrs.append(item.icon)
        }
        self.icon_stack.images_address = icon_addrs
        self.icon_stack.ever_inited = 0
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
                    x.height.equalTo((LKRoot.container_package_repo_DBSync.count + 1) * 62 + 5 - 32)
                }
                self.icon_stack.apart_init()
                self.table_view.reloadData()
                UIApplication.shared.endIgnoringInteractionEvents()
                IHProgressHUD.dismiss()
                CallB()
            })
        }
    }
    
    @objc func add_button_recall(sender: Any?) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alert = UIAlertController(title: "添加".localized(),
                                      message: "请在这里输入 软件源 地址".localized(),
                                      preferredStyle: .alert)
        var inputTextField: UITextField?
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "https://"
            let read = String().readClipBoard()
            if read != "" && read.contains("http") && read.contains("://") && URL(string: read) != nil &&
                LKRoot.container_string_store["ClipBoard"] != read {
                LKRoot.container_string_store["ClipBoard"] = read
                textField.text = read
            } else {
                textField.text = "https://"
            }
            inputTextField = textField
        })
        alert.addAction(UIAlertAction(title: "取消".localized(), style: .cancel, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "确认".localized(), style: .destructive, handler: { (_) in
            var read = inputTextField?.text ?? ""
            if read == "" || !(read.contains(".") && read.contains(":")) || URL(string: read) == nil { // iPv6 -> :
                print("[i] 这用户输入不合法嗨呀好气呀！")
                let statusAlert = StatusAlert()
                statusAlert.image = UIImage(named: "Warning")
                statusAlert.title = "添加失败".localized()
                statusAlert.message = "请检查输入内容并在试一次".localized()
                statusAlert.canBePickedOrDismissed = true
                statusAlert.showInKeyWindow()
                return
            }
            for repo in LKRoot.container_package_repo_DBSync where repo.link == read {
                print("[*] 这个软件源已经存在了撒咱们撤")
                let statusAlert = StatusAlert()
                statusAlert.image = UIImage(named: "Exists")
                statusAlert.title = "⚠️".localized()
                statusAlert.message = "这个地址已经存在".localized()
                statusAlert.canBePickedOrDismissed = true
                statusAlert.showInKeyWindow()
                return
            }
            //             开始处理咯
            if !read.hasSuffix("/") {
                read += "/"
            }
            IHProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            LKRoot.queue_dispatch.async {
                let new = DBMPackageRepos()
                new.link = read
                new.sort_id = LKRoot.container_package_repo_DBSync.count
                try? LKRoot.root_db?.insertOrReplace(objects: new, intoTable: common_data_handler.table_name.LKPackageRepos.rawValue)
                LKRoot.ins_common_operator.PR_sync_and_download(sync_all: false) { (ret) in
                    DispatchQueue.main.async {
                        if ret != 0 || (LKRoot.container_string_store["REFRESH_CONTAIN_BAD_REFRESH_PR"] ?? "").contains(new.link ?? "") {
                            LKRoot.container_string_store["REFRESH_CONTAIN_BAD_REFRESH_PR"] = ""
                            IHProgressHUD.dismiss()
                            print("[*] 刷新失败")
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "Warning")
                            statusAlert.title = "刷新失败".localized()
                            statusAlert.message = "请检查源地址或网络连接并在试一次。".localized()
                            statusAlert.canBePickedOrDismissed = true
                            statusAlert.showInKeyWindow()
                            try? LKRoot.root_db?.delete(fromTable: common_data_handler.table_name.LKPackageRepos.rawValue, where: DBMPackageRepos.Properties.link == read)
                            UIApplication.shared.endIgnoringInteractionEvents()
                            return
                        }
                        self.update_user_interface {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "Done")
                            statusAlert.title = "添加成功".localized()
                            statusAlert.message = (LKRoot.container_package_repo_DBSync.last?.name ?? "") + " 已经添加到你的仓库".localized()
                            statusAlert.canBePickedOrDismissed = true
                            statusAlert.showInKeyWindow()
                        }
                    }
                }
            }
        }))
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func share_button_recall(sender: Any?) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        var out = String()
        for item in LKRoot.container_package_repo_DBSync {
            out += item.link
            out += "\n"
        }
        out = out.dropLast().to_String()
        let some = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        some.center = (sender as? UIView)?.center ?? CGPoint(x: 0, y: 0)
        out.share(from_view: some)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            some.removeFromSuperview()
        }
    }
    
    func touched_cell(which: IndexPath) {
        
    }
    
}

