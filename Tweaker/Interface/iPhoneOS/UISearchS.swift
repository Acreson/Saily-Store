//
//  UISearchS.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UISearchS: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        return 4
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
            let header = LKRoot.ins_view_manager.create_AS_home_header_view(title_str: "搜索中心".localized(),
                                                                            sub_str: "在这里，寻找可能".localized(),
                                                                            image_str: "NAMED:Search")
            ret.contentView.addSubview(header)
            header.snp.makeConstraints { (x) in
                x.edges.equalTo(ret.contentView.snp.edges)
            }
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 1:
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 2:
            ret.backgroundView?.backgroundColor = .clear
            ret.backgroundColor = .clear
        case 3:
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
        case 1: return 40
        default: return 180
        }
    }
    
}
