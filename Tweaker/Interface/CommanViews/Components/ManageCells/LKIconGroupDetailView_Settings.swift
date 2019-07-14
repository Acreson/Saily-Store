//
//  LKIconGroupDetailView_Settings.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension manage_views {
  
    class LKIconGroupDetailView_Settings: UIView, UITableViewDataSource {
        
        var initd = false
        
        let contentView = UIView()
        let table_view_container = UIView()
        
        let table_view = UITableView()
        let icon_stack = common_views.LKIconStack()
        
        init() {
            super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func apart_init(father: UIView?) {
            
            initd = true
            
            let RN_ANCHOR_O = 24
            let RN_ANCHOR_I = 16
            
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
            title_view.text = "设置".localized()
            title_view.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
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
            
            // 图标组
//            icon_stack.images_address = ["AppIcon", "Setting"]
            icon_stack.images_address = ["Setting"]
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
                x.top.equalTo(sep.snp.bottom).offset(8)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.bottom.equalTo(contentView.snp.bottom).offset(-8)
            }
            
            contentView.bringSubviewToFront(self)
            
            table_view.delegate = self
            table_view.dataSource = self
            table_view.allowsSelection = false
            table_view.isScrollEnabled = false
            table_view_container.addSubview(table_view)
            table_view.snp.makeConstraints { (x) in
                x.top.equalTo(self.table_view_container.snp.top)
                x.left.equalTo(contentView.snp.left).offset(8)
                x.right.equalTo(contentView.snp.right).offset(-8)
                x.bottom.equalTo(contentView.snp.bottom).offset(-8)
            }
            table_view.separatorColor = .clear
            table_view.backgroundColor = .clear
            table_view.beginUpdates()
            table_view.reloadData()
            table_view.endUpdates()
            
        }
       
    }
    
}

extension manage_views.LKIconGroupDetailView_Settings: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = UITableViewCell()
        let LR_OFFSET: CGFloat = 14
        let LRT_OFFSET: CGFloat = 0 // Left Right Title Offset 以免有强迫症和我取名过不去
        let touched_color = UIColor.lightGray
        ret.backgroundColor = .clear
        switch indexPath.row {
        case 0:
            let new = UILabel(text: "手动加载".localized())
            new.font = .boldSystemFont(ofSize: 22)
            new.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left).offset(LR_OFFSET - LRT_OFFSET)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right).offset(-LR_OFFSET + LRT_OFFSET)
            }
            return ret
        case 1:
            let new = UIButton()
            new.setTitle("刷新 - 新闻源".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(refresh_np), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 2:
            let new = UIButton()
            new.setTitle("刷新 - 软件源 & 软件包".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(refresh_pack), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 3:
            let new = UIButton()
            new.setTitle("导入 - 新闻源".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(import_news_repo), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 4:
            let new = UIButton()
            new.setTitle("导入 - 软件源".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(import_package_repo), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 5:
            let new = UILabel(text: "交互界面".localized())
            new.font = .boldSystemFont(ofSize: 22)
            new.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left).offset(LR_OFFSET - LRT_OFFSET)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right).offset(-LR_OFFSET + LRT_OFFSET)
            }
            return ret
        case 6:
            let new = UILabel(text: "外观 - 启用黑夜模式".localized())
            new.font = .systemFont(ofSize: 18)
            new.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left).offset(LR_OFFSET)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right).offset(-60)
            }
            let switcher = UISwitch()
            switcher.tintColor = .black
            switcher.onTintColor = .black
            switcher.transform = CGAffineTransform(scaleX: 0.66, y: 0.66)
            ret.contentView.addSubview(switcher)
            switcher.snp.makeConstraints { (x) in
                x.centerY.equalTo(new.snp.centerY).offset(-0.5)
                x.right.equalTo(ret.contentView.snp.right).offset(-LR_OFFSET)
            }
            switcher.addTarget(self, action: #selector(switch_dark_mode), for: .valueChanged)
            return ret
        case 7:
            let new = UIButton()
            new.setTitle("外观 - 全局卡片圆角".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(set_gobal_round_rate), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 8:
            let new = UILabel(text: "软件逻辑".localized())
            new.font = .boldSystemFont(ofSize: 22)
            new.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left).offset(LR_OFFSET - LRT_OFFSET)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right).offset(-LR_OFFSET + LRT_OFFSET)
            }
            return ret
        case 9:
            let new = UIButton()
            new.setTitle("通用 - 全局下载超时".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(set_gobal_timeout), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 10:
            let new = UIButton()
            new.setTitle("通用 - 获取设备 UDID".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(get_device_udid), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 11:
            let new = UILabel(text: "关于".localized())
            new.font = .boldSystemFont(ofSize: 22)
            new.textColor = LKRoot.ins_color_manager.read_a_color("main_title_three")
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left).offset(LR_OFFSET - LRT_OFFSET)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right).offset(-LR_OFFSET + LRT_OFFSET)
            }
            return ret
        case 12:
            let new = UIButton()
            new.setTitle("获取 - 设备信息".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(get_device_info), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 13:
            let new = UIButton()
            new.setTitle("获取 - 软件信息".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(get_software_info), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 14:
            let new = UIButton()
            new.setTitle("帮助 - 联系开发者".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(get_software_info), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 15:
            let new = UIButton()
            new.setTitle("分享 - 社交媒体".localized(), for: .normal)
            new.titleLabel?.font = .systemFont(ofSize: 18)
            new.setTitleColor(LKRoot.ins_color_manager.read_a_color("main_title_three"), for: .normal)
            new.setTitleColor(touched_color, for: .highlighted)
            new.addTarget(self, action: #selector(get_software_info), for: .touchUpInside)
            new.contentHorizontalAlignment = .left
            new.contentEdgeInsets = UIEdgeInsets(top: 0, left: LR_OFFSET, bottom: 0, right: 0)
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right)
            }
            return ret
        case 16:
            let new = UILabel(text: "Copyright © 2019 Tweaker Team. All rights reserved.".localized())
            new.font = .boldSystemFont(ofSize: 8)
            new.textColor = .lightGray
            new.textAlignment = .center
            ret.contentView.addSubview(new)
            new.snp.makeConstraints { (x) in
                x.top.equalTo(ret.contentView.snp.top)
                x.left.equalTo(ret.contentView.snp.left).offset(LR_OFFSET - LRT_OFFSET)
                x.bottom.equalTo(ret.contentView.snp.bottom)
                x.right.equalTo(ret.contentView.snp.right).offset(-LR_OFFSET + LRT_OFFSET)
            }
            return ret
        default:
            return ret
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title_size: CGFloat = 48
        let button_size: CGFloat = 30
        switch indexPath.row {
        case 0, 5, 8, 11:
            return title_size
        default:
            return button_size
        }
    }
    
    @objc func refresh_np() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        IHProgressHUD.show()
        LKRoot.queue_dispatch.async {
            LKRoot.ins_common_operator.NR_sync_and_download { (_) in
                LKRoot.manager_reg.nr.update_user_interface {
                    let statusAlert = StatusAlert()
                    statusAlert.image = UIImage(named: "Done")
                    statusAlert.title = " ".localized()
                    statusAlert.message = "你已经成功的刷新了新闻源".localized()
                    statusAlert.canBePickedOrDismissed = true
                    statusAlert.showInKeyWindow()
                }
            }
        }
    }
    
    @objc func refresh_pack() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        IHProgressHUD.show()
        LKRoot.queue_dispatch.async {
            LKRoot.ins_common_operator.PR_sync_and_download(sync_all: true) { (_) in
                LKRoot.manager_reg.pr.update_user_interface {
                    let statusAlert = StatusAlert()
                    statusAlert.image = UIImage(named: "Done")
                    statusAlert.title = "刷新软件源成功".localized()
                    statusAlert.message = "软件包的更新将在后台进行。".localized()
                    statusAlert.canBePickedOrDismissed = true
                    statusAlert.showInKeyWindow()
                }
            }
        }
    }
    
    func exists_check_nr(_ w: String) -> Bool {
        LKRoot.manager_reg.nr.re_sync()
        for item in LKRoot.container_news_repo_DBSync where item.link == w {
            return false
        }
        return true
    }
    
    @objc func import_news_repo() {
        let read = String().readClipBoard().cleanRN()
        var read_out = [String]()
        var msg_str = "准备导入如下的新闻源\n".localized()
        for item in read.split(separator: "\n") where item.hasPrefix("http") && exists_check_nr(item.to_String()) {
            read_out.append(item.to_String())
            msg_str.append(item.to_String())
            msg_str.append("\n")
        }
        if read_out.count < 1 {
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "Warning")
            statusAlert.title = "失败".localized()
            statusAlert.message = "没有在剪贴板中找到有效的新闻源地址".localized()
            statusAlert.canBePickedOrDismissed = true
            statusAlert.showInKeyWindow()
            return
        }
        
        let alert = UIAlertController(title: "即将导入".localized(), message: msg_str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "执行", style: .destructive, handler: { (_) in
            IHProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            LKRoot.queue_dispatch.async {
                var index = 0
                for item in read_out {
                    let new = DBMNewsRepo()
                    new.link = item
                    new.sort_id = LKRoot.container_news_repo_DBSync.count + index
                    index += 1
                    try? LKRoot.root_db?.insertOrReplace(objects: new, intoTable: common_data_handler.table_name.LKNewsRepos.rawValue)
                }
                LKRoot.ins_common_operator.NR_sync_and_download { (_) in
                    DispatchQueue.main.async {
                        LKRoot.manager_reg.nr.update_user_interface {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "Done")
                            statusAlert.title = "导入成功".localized()
                            statusAlert.message = "请考虑手动检查导入的完整性".localized()
                            statusAlert.canBePickedOrDismissed = true
                            statusAlert.showInKeyWindow()
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        alert.presentToCurrentViewController()
    }
    
    func exists_check_pr(_ w: String) -> Bool {
        LKRoot.manager_reg.pr.re_sync()
        for item in LKRoot.container_package_repo_DBSync where item.link == w {
            return false
        }
        return true
    }
    
    @objc func import_package_repo() {
        let read = String().readClipBoard().cleanRN()
        var read_out = [String]()
        var msg_str = "准备导入如下的软件源\n".localized()
        for item in read.split(separator: "\n") where item.hasPrefix("http") && exists_check_pr(item.to_String()) {
            read_out.append(item.to_String())
            msg_str.append(item.to_String())
            msg_str.append("\n")
        }
        if read_out.count < 1 {
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "Warning")
            statusAlert.title = "失败".localized()
            statusAlert.message = "没有在剪贴板中找到有效的软件源地址".localized()
            statusAlert.canBePickedOrDismissed = true
            statusAlert.showInKeyWindow()
            return
        }
        
        let alert = UIAlertController(title: "即将导入".localized(), message: msg_str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "执行", style: .destructive, handler: { (_) in
            IHProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            LKRoot.queue_dispatch.async {
                var index = 0
                for item in read_out {
                    let new = DBMPackageRepos()
                    new.link = item
                    new.sort_id = LKRoot.container_package_repo_DBSync.count + index
                    index += 1
                    try? LKRoot.root_db?.insertOrReplace(objects: new, intoTable: common_data_handler.table_name.LKPackageRepos.rawValue)
                }
                LKRoot.ins_common_operator.PR_sync_and_download(sync_all: true) { (_) in
                    DispatchQueue.main.async {
                        LKRoot.manager_reg.pr.update_user_interface {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "Done")
                            statusAlert.title = "导入成功".localized()
                            statusAlert.message = "请考虑手动检查导入的完整性".localized()
                            statusAlert.canBePickedOrDismissed = true
                            statusAlert.showInKeyWindow()
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        alert.presentToCurrentViewController()
    }
    
    @objc func switch_dark_mode() {
        
    }
    
    @objc func set_gobal_round_rate() {
        
    }
    
    @objc func set_gobal_timeout() {
        
    }
    
    @objc func get_device_udid() {
        
    }
    
    @objc func get_device_info() {
        
    }
    
    @objc func get_software_info() {
        
    }
    
    @objc func get_help() {
        
    }
    
    @objc func share() {
        
    }
}


