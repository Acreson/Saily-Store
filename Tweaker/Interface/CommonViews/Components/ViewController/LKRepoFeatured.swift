//
//  LKRepoFeatured.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/19.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

// swiftlint:disable:next type_body_length
class LKRepoFeatured: UIViewController {
    
    var repo: DMPackageRepos?
    var contentView = UIScrollView()
    let content = UIScrollView()
    var sum_content_height = 0
    
    var currentAnchor = UIView()
    var bannerPackage = [String]()
    
    required init(rr: DMPackageRepos) {
        super.init(nibName: nil, bundle: nil)
        repo = rr
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_background")
        
        if LKRoot.settings?.use_dark_mode ?? false {
            navigationController?.navigationBar.barStyle = .black
        }
        
        if repo?.link == nil || repo?.link == "" {
            presentStatusAlert(imgName: "Warning", title: "未知错误".localized(), msg: "请尝试在设置页面刷新软件源".localized())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        view.addSubview(contentView)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
        
        let icon = UIImageView()
        icon.sd_setImage(with: URL(string: repo!.icon), placeholderImage: UIImage(named: "Gary")) { [weak self] (img, err, _, _) in
            if err != nil || img == nil {
                if let image = UIImage(named: self?.repo?.icon ?? "somethingthatdoesntexistsinmybundle") {
                    icon.image = image
                } else {
                    icon.image = UIImage(named: "AppIcon")
                }
            }
        }
        
        icon.setRadiusINT(radius: LKRoot.settings?.card_radius ?? 8)
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(22)
            x.top.equalTo(self.view.snp.top).offset(22)
            x.width.equalTo(55)
            x.height.equalTo(55)
        }
        
        sum_content_height += 55 + 22
        
        let label2 = UILabel()
        label2.text = repo?.link
        label2.font = .boldSystemFont(ofSize: 14)
        label2.textColor = LKRoot.ins_color_manager.read_a_color("sub_text")
        contentView.addSubview(label2)
        label2.snp.makeConstraints { (x) in
            x.left.equalTo(icon.snp.right).offset(22)
            x.bottom.equalTo(icon.snp.bottom)
            x.right.equalTo(self.view.snp.right).offset(-22)
            x.height.equalTo(17)
        }
        
        let label = UILabel()
        label.text = repo?.name
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        contentView.addSubview(label)
        label.snp.makeConstraints { (x) in
            x.left.equalTo(icon.snp.right).offset(22)
            x.bottom.equalTo(label2.snp.top).offset(-4)
            x.right.equalTo(self.view.snp.right).offset(-22)
            x.height.equalTo(30)
        }
        
        let sep = UIView()
        sep.backgroundColor = .gray
        sep.alpha = 0.5
        contentView.addSubview(sep)
        sep.snp.makeConstraints { (x) in
            x.left.equalTo(icon.snp.left)
            x.right.equalTo(label2.snp.right)
            x.height.equalTo(0.5)
            x.top.equalTo(icon.snp.bottom).offset(12)
        }
        
        sum_content_height += 1
        
        let desstr = UITextView()
        desstr.backgroundColor = .clear
        desstr.text = repo?.desstr
        desstr.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        desstr.font = .boldSystemFont(ofSize: 14)
        desstr.isScrollEnabled = false
        contentView.addSubview(desstr)
        desstr.snp.makeConstraints { (x) in
            x.left.equalTo(icon.snp.left)
            x.right.equalTo(label2.snp.right)
            x.top.equalTo(sep.snp.bottom).offset(12)
            x.height.equalTo(33)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            desstr.snp.remakeConstraints { (x) in
                x.left.equalTo(icon.snp.left)
                x.right.equalTo(label2.snp.right)
                x.top.equalTo(sep.snp.bottom).offset(12)
                x.height.equalTo(desstr.intrinsicContentSize.height)
            }
            self.sum_content_height += Int(desstr.height)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.contentView.contentSize.height = CGFloat(self.sum_content_height)
        }
     
        self.currentAnchor = desstr
        
        LKRoot.queue_dispatch.async {
            self.doSetupFeaturedJson()
        }
        
    }
    
    func setupLakrFeatured() { // 😂
        using_bottom_margins()
        setup_SeparatorView()
        
        
        
        contentView.contentSize.height = CGFloat(sum_content_height)
    }
    
    func doSetupFeaturedJson() {
        
        guard let featured_url = URL(string: (repo?.link ?? "") + "sileo-featured.json" ) else {
            DispatchQueue.main.async {
                self.setupLakrFeatured()
            }
            return
        }
        
        print("[*] 准备从 " + featured_url.absoluteString + " 请求FeaturedJson数据。")
        
        AF.request(featured_url, method: .get, headers: nil).response(queue: LKRoot.queue_dispatch) { (resp) in
            guard let data = resp.data else {
                DispatchQueue.main.async {
                    self.setupLakrFeatured()
                }
                return
            }
            var read = String(data: data, encoding: .utf8)
            if read == nil || read == "" {
                read = String(data: data, encoding: .ascii)
            }
            if read == nil || read == "" {
                DispatchQueue.main.async {
                    self.setupLakrFeatured()
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: read!.data(using: .utf8)!, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.doJsonSetupView(json: json)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.setupLakrFeatured()
                }
                return
            }
        }
        
    }
    
    func doJsonSetupView(json: [String : Any]) {
        
        print("[*] 开始校验 FeaturedJson 数据")
        
        if json["class"] as? String != "FeaturedBannersView" {
            DispatchQueue.main.async {
                self.setupLakrFeatured()
            }
            return
        }
        
        guard let banners = json["banners"] as? [[String : Any]] else {
            DispatchQueue.main.async {
                self.setupLakrFeatured()
            }
            return
        }
        
        let itemSize = NSCoder.cgSize(for: json["itemSize"] as? String ?? "")
        
        if itemSize.width < 1 || itemSize.height < 1 {
            DispatchQueue.main.async {
                self.setupLakrFeatured()
            }
            return
        }
        
        let radius = json["itemCornerRadius"] as? Double ?? 0
        
        print("[*] FeaturedJson 数据校验成功")
        
        let plh = UIView()
        plh.clipsToBounds = false
        contentView.addSubview(plh)
        plh.snp.makeConstraints { (x) in
            x.top.equalTo(self.currentAnchor.snp.bottom).offset(12)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
            x.height.equalTo(itemSize.height)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints { (x) in
            x.edges.equalTo(plh.snp.edges)
        }
        
        var contentSizeWidth = CGFloat(0)
        
        var innerAnchor = UIView()
        content.addSubview(innerAnchor)
        innerAnchor.snp.makeConstraints { (x) in
            x.top.equalTo(plh.snp.top)
            x.bottom.equalTo(plh.snp.bottom)
            x.left.equalTo(content.snp.left)
            x.width.equalTo(0)
        }
        
        var index = 0
        inner: for banner in banners {
            guard let url = URL(string: banner["url"] as? String ?? "") else {
                continue inner
            }
            guard let package = banner["package"] as? String else {
                continue inner
            }
            guard let title = banner["title"] as? String else {
                continue inner
            }
            contentSizeWidth += itemSize.width + 16
            let img = UIImageView()
            content.addSubview(img)
            img.snp.makeConstraints { (x) in
                x.top.equalTo(plh.snp.top)
                x.bottom.equalTo(plh.snp.bottom)
                x.left.equalTo(innerAnchor.snp.right).offset(16)
                x.width.equalTo(itemSize.width)
            }
            img.sd_setImage(with: url, placeholderImage: UIImage(named: "Gary")) { (_, _, _, _) in
                let label = UILabel()
                label.textColor = .white
                label.font = .boldSystemFont(ofSize: 22)
                label.text = title
                self.content.addSubview(label)
                label.snp.makeConstraints({ (x) in
                    x.left.equalTo(img.snp.left).offset(12)
                    x.bottom.equalTo(img.snp.bottom).offset(-12)
                    x.right.equalTo(img.snp.right).offset(-12)
                    x.height.equalTo(22)
                })
            }
            img.setRadiusCGF(radius: CGFloat(radius))
            img.isUserInteractionEnabled = false
            img.contentMode = .scaleAspectFill
            
            let button = UIButton()
            content.addSubview(button)
            button.snp.makeConstraints { (x) in
                x.edges.equalTo(img.snp.edges)
            }
            
            bannerPackage.append(package)
            button.tag = index
            button.addTarget(self, action: #selector(button2Package(sender:)), for: .touchUpInside)
            index += 1
            
            innerAnchor = img
        }
        
        contentSizeWidth += 16
        
        currentAnchor = plh
        
        content.showsVerticalScrollIndicator = false
        content.showsHorizontalScrollIndicator = false
        content.contentSize = CGSize(width: contentSizeWidth, height: 0)
        
        sum_content_height += Int(itemSize.height + 12)
        
        DispatchQueue.main.async {
            self.setupLakrFeatured()
        }
    }
    
    @objc func button2Package(sender: UIButton) {
        let tag = sender.tag
        if tag < 0 || tag >= bannerPackage.count {
            presentStatusAlert(imgName: "Warning", title: "未知错误".localized(), msg: "请尝试在设置页面刷新软件源".localized())
            return
        }
        guard let pack = LKRoot.container_packages[bannerPackage[tag]]?.copy() else {
            presentStatusAlert(imgName: "Warning", title: "未知错误".localized(), msg: "请尝试在设置页面刷新软件源".localized())
            return
        }
        
        let vers = pack.version
        if vers.count < 1 {
            presentStatusAlert(imgName: "Warning", title: "未知错误".localized(), msg: "请尝试在设置页面刷新软件源".localized())
            return
        }
        pack.version.removeAll()
        let versionSorted = LKRoot.ins_common_operator.PAK_versions_sort(versions: vers)
        var result = [String : [String : [String : String]]]()
        all: for item in versionSorted {
            guard let versionInner = vers[item] else {
                presentStatusAlert(imgName: "Warning", title: "未知错误".localized(), msg: "请尝试在设置页面刷新软件源".localized())
                return
            }
            for i in versionInner where i.key == repo?.link ?? "thisisanerrorlinkyouwonthave" {
                let t = [i.key : i.value]
                result[item] = t
                break all
            }
        }
        
        if result.count != 1 {
            presentStatusAlert(imgName: "Warning", title: "未知错误".localized(), msg: "这个软件源可能不包含这个软件包".localized())
            return
        }
        pack.version = result
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                presentPackage(pack: pack)
            })
        }
        
    }
    
    func using_bottom_margins(height: Int = 12) {
        let d = UIView()
        contentView.addSubview(d)
        d.snp.makeConstraints { (x) in
            x.centerX.equalTo(self.view.snp.centerX)
            x.width.equalTo(50)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.height.equalTo(height)
        }
        currentAnchor = d
        sum_content_height += height
    }
    
    func setup_SeparatorView() {
        let sep = UIView()
        sep.backgroundColor = .gray
        sep.alpha = 0.233
        contentView.addSubview(sep)
        sep.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(18)
            x.right.equalTo(self.view.snp.right).offset(-18)
            x.top.equalTo(self.currentAnchor.snp.bottom)
            x.height.equalTo(0.5)
        }
        sum_content_height += 1
        self.currentAnchor = sep
    }
    
}


