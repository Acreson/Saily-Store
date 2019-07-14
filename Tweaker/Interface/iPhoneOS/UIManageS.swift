//
//  UIManageS.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIManageS: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var table_view: UITableView = UITableView()
    var header_view: UIView?
    
    // 控制 NAV
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if LKRoot.container_string_store["REQ_REFRESH_UI_MANAGE"] == "FALSE" {
            LKRoot.container_string_store["REQ_REFRESH_UI_MANAGE"] = "FALSE"
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.async {
                self.table_view.beginUpdates()
                UIView.animate(withDuration: 0.5, animations: {
                    self.table_view.endUpdates()
                }, completion: { (_) in
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.separatorColor = .clear
        table_view.clipsToBounds = false
        table_view.delegate = self
        table_view.dataSource = self
        table_view.allowsSelection = false
        table_view.backgroundView?.backgroundColor = .clear
        table_view.backgroundColor = .clear
        self.view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_back_ground")
        view.addSubview(table_view)
        table_view.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return do_the_height_math(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return do_the_height_math(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = UITableViewCell()
        switch indexPath.row {
        case 0:        // 处理一下头条
            let header = LKRoot.ins_view_manager.create_AS_home_header_view(title_str: "管理中心".localized(),
                                                                            sub_str: "在这里，你和你的全部".localized(),
                                                                            image_str: "NAMED:AccountHeadIconPlaceHolder")
            ret.contentView.addSubview(header)
            header.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 1:
            let header = manage_views.LKActiveShineCell()
            header.apart_init(father: table_view)
            ret.contentView.addSubview(header)
            header.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 2:
            let news_repo_manager = manage_views.LKIconGroupDetailView_NewsRepoSP()
            news_repo_manager.apart_init(father: tableView)
            ret.contentView.addSubview(news_repo_manager)
            news_repo_manager.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 3:
            let package_repo_manager = manage_views.LKIconGroupDetailView_PackageRepoSP()
            package_repo_manager.apart_init(father: tableView)
            ret.contentView.addSubview(package_repo_manager)
            package_repo_manager.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 4:
            let package_repo_manager = manage_views.LKIconGroupDetailView_RecentUpdate()
            package_repo_manager.apart_init(father: tableView)
            ret.contentView.addSubview(package_repo_manager)
            package_repo_manager.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        default:
            ret.backgroundColor = .clear
        }
        return ret
    }
    
    func do_the_height_math(indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 110
        case 1:
            return 16
//            if (LKRoot.container_string_store["STR_SIG_PROGRESS"] ?? "SIGCLEAR") == "SIGCLEAR" {
//                return 0
//            } else {
//                return 22
//            }
        case 2:
            if LKRoot.container_manage_cell_status["NP_IS_COLLAPSED"] ?? true {
                return 164
            } else {
                return 164 + CGFloat(LKRoot.container_news_repo_DBSync.count + 1) * 62 - 32
            }
        case 3:
            if LKRoot.container_manage_cell_status["PR_IS_COLLAPSED"] ?? true {
                return 171
            } else {
                return 171 + CGFloat(LKRoot.container_package_repo_DBSync.count + 1) * 62 - 32
            }
        case 4:
            if LKRoot.container_manage_cell_status["RU_IS_COLLAPSED"] ?? true {
                return 157
            } else {
                if LKRoot.container_recent_update.count > 12 {
                    return 157 + 12 * 62
                }
                return 157 + CGFloat(LKRoot.container_recent_update.count) * 62
            }
        default: return 180
        }
    }
    
}
