//
//  LKPackageListController.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/17.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class LKPackageListController: UIViewController {
    
    
    let table_view = UITableView()
    var items = [DBMPackage]()
    let cell_id = UUID().uuidString
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_background")
        
        table_view.register(cell_views.LKIconTVCell.self, forCellReuseIdentifier: cell_id)
        table_view.delegate = self
        table_view.dataSource = self
        table_view.backgroundColor = .clear
        table_view.separatorColor = .clear
        
        view.addSubview(table_view)
        table_view.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
        
        if LKRoot.settings?.use_dark_mode ?? false {
            navigationController?.navigationBar.barStyle = .blackOpaque
        } else {
            navigationController?.navigationBar.barStyle = .default
        }
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
}

extension LKPackageListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as? cell_views.LKIconTVCell ?? cell_views.LKIconTVCell()
        let pack = items[indexPath.row]
        let version = LKRoot.ins_common_operator.PAK_read_newest_version(pack: pack).1
        ret.title.text = LKRoot.ins_common_operator.PAK_read_name(version: version)
        ret.link.text = LKRoot.ins_common_operator.PAK_read_description(version: version)
        if ret.link.text == "" {
            ret.link.text = "软件包无可用描述。".localized()
        }
        let icon_link = LKRoot.ins_common_operator.PAK_read_icon_addr(version: version)
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
                ret.icon.image = UIImage(named: TWEAK_DEFAULT_IMG_NAME)
            }
        }
        
        if indexPath.row == items.count - 1 {
            ret.sep.alpha = 0
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
            self.items[index.row].id.pushClipBoard()
            presentStatusAlert(imgName: "Done",
                               title: "成功".localized(),
                               msg: "这个软件包的名字已经复制到剪贴板".localized())
        }
        share.backgroundColor = LKRoot.ins_color_manager.read_a_color("button_tint_color")
        
        return [share]
    }
    
    func touched_cell(which: IndexPath) {
        
    }
}


