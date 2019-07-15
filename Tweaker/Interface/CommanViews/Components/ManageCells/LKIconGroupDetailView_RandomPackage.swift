//
//  LKIconGroupDetailView_RandomPackage.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

let ALL_AT_ASSETS = ["ATAdministration", "ATAdult", "ATAlkaline", "ATAll Packages", "ATApp Addons", "ATApplications", "ATApps", "ATArchiving", "ATBrowse Repositories", "ATCarrier Bundles", "ATChariz", "ATControl Center (Modules)", "ATCydgets", "ATData Storage", "ATDefault", "ATDeveloper", "ATDevelopment", "ATeBooks", "ATEducation", "ATEntertainment", "ATFonts", "ATGames", "ATHunspell_Dictionaries", "ATInstalled Packages", "ATJava", "ATKeyboards", "ATLocalization", "ATLockInfo Addons", "ATLockscreen", "ATMessaging", "ATModMyi (Archive)", "ATMultimedia", "ATNavigation", "ATNetwork", "ATPackaging", "ATPackix", "ATPreference Bundle", "ATProductivity", "ATRecent Packages", "ATRepositories", "ATRingtones", "ATSaurik", "ATScripting", "ATSecurity", "ATSocial", "ATSoundboards", "ATSystem", "ATTerminal", "ATTest", "ATText Editors", "ATThemes", "ATTools", "ATToys", "ATTweaks", "ATUpdated Packages", "ATUtilities", "ATWallpapers", "ATWidgets", "ATZeppelin"]

extension manage_views {
    
    class LKIconGroupDetailView_RandomPackage: UIView, UITableViewDataSource {
        
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
            table_view.register(cell_views.LKIconTVCell.self, forCellReuseIdentifier: "LKIconGroupDetailView_RandomPackage_TVID")
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func apart_init(father: UIView?) {
            
            initd = true
            
            LKRoot.container_manage_cell_status["RP_IS_COLLAPSED"] = is_collapsed
            
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
            title_view.text = "给你惊喜".localized()
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
            sub_title_view.text = "我们从你的软件源里面随机获取了一些软件包，希望你能喜欢。注意：你每一次合上选项块我们都换更换软件包。且行且珍惜。".localized()
            sub_title_view.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
            sub_title_view.font = .systemFont(ofSize: 10)
            sub_title_view.isUserInteractionEnabled = false
            sub_title_view.backgroundColor = .clear
            contentView.addSubview(sub_title_view)
            sub_title_view.snp.makeConstraints { (x) in
                x.top.equalTo(title_view.snp.bottom).offset(-4)
                x.left.equalTo(self.contentView.snp.left).offset(RN_ANCHOR_I - 4)
                x.right.equalTo(self.contentView.snp.right).offset(-RN_ANCHOR_I + 4)
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
            icon_stack.images_address.removeAll()
            icon_stack.images_address.append(ALL_AT_ASSETS.randomElement()!)
            icon_stack.images_address.append(ALL_AT_ASSETS.randomElement()!)
            icon_stack.images_address.append(ALL_AT_ASSETS.randomElement()!)
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
            expend_button.setTitle("点击来获取惊喜 ▼".localized(), for: .normal)
            expend_button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_two"), for: .normal)
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
            LKRoot.container_packages_randomfun_DBSync.removeAll()
            if LKRoot.container_packages.count < 1 {
                return
            }
            LKRoot.container_packages_randomfun_DBSync.append(LKRoot.container_packages.randomElement()!)
            LKRoot.container_packages_randomfun_DBSync.append(LKRoot.container_packages.randomElement()!)
            LKRoot.container_packages_randomfun_DBSync.append(LKRoot.container_packages.randomElement()!)
            LKRoot.container_packages_randomfun_DBSync.append(LKRoot.container_packages.randomElement()!)
        }
        
        func update_status() {
            LKRoot.container_manage_cell_status["RP_IS_COLLAPSED"] = is_collapsed
        }
        
        @objc func expend_self() {
            
            re_sync()
            
            if LKRoot.container_packages_randomfun_DBSync.count < 1 {
                UIView.transition(with: expend_button, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.expend_button.setTitle("你需要一些软件源和软件包我们才能给你惊喜".localized(), for: .normal)
                    self.expend_button.setTitleColor(.red, for: .normal)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.transition(with: self.expend_button, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.expend_button.setTitle("点击来获取惊喜 ▼".localized(), for: .normal)
                        self.expend_button.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_two"), for: .normal)
                    })
                }
                return
            }
            
            table_view.reloadData()
            table_view.snp.remakeConstraints { (x) in
                x.top.equalTo(self.table_view_container.snp.top)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.height.equalTo(LKRoot.container_packages_randomfun_DBSync.count * 62 + 5)
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
                    
                    self.icon_stack.images_address.removeAll()
                    self.icon_stack.images_address.append(ALL_AT_ASSETS.randomElement()!)
                    self.icon_stack.images_address.append(ALL_AT_ASSETS.randomElement()!)
                    self.icon_stack.images_address.append(ALL_AT_ASSETS.randomElement()!)
                    self.icon_stack.apart_init()
                    
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
        
        func update_interface() {
            re_sync()
            if LKRoot.container_packages_randomfun_DBSync.count < 1 {
                collapse_self()
            } else if !is_collapsed {
                table_view.reloadData()
            }
        }
        
    }
    
}

extension manage_views.LKIconGroupDetailView_RandomPackage: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LKRoot.container_packages_randomfun_DBSync.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = tableView.dequeueReusableCell(withIdentifier: "LKIconGroupDetailView_RandomPackage_TVID", for: indexPath) as? cell_views.LKIconTVCell ?? cell_views.LKIconTVCell()
        let pack = LKRoot.container_packages_randomfun_DBSync[indexPath.row]
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
        return ret
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row < LKRoot.container_packages_randomfun_DBSync.count {
            touched_cell(which: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "分享".localized()) { _, index in
            LKRoot.container_packages_randomfun_DBSync[index.row].id.pushClipBoard()
            presentStatusAlert(imgName: "Done",
                               title: "成功".localized(),
                               msg: "这个软件包的名字已经复制到剪贴板".localized())
        }
        share.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_title_two")
        
        return [share]
    }
    
    func touched_cell(which: IndexPath) {
        
    }
    
}


