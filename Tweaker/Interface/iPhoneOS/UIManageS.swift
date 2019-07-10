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
            let news_repo_manager = LKIconGroupDetailView_NewsRepoSP()
            news_repo_manager.apart_init(father: tableView)
            ret.contentView.addSubview(news_repo_manager)
            news_repo_manager.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        default:
            ret.backgroundColor = .white
        }
        return ret
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
    
    func do_the_height_math(indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 108
        case 1:
            if LKRoot.container_manage_cell_status["NewsRepo"] ?? true {
                return 180
            } else {
                return 180 + CGFloat(LKRoot.container_news_repo.count + 1) * 62 - 32
            }
        default: return 180
        }
    }
    
}
