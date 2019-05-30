//
//  OperatorNewsRepo.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/29.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension app_opeerator {
    
    func NP_sync_and_download(CallB: @escaping (Int) -> Void) {
        // 从数据库读取列表
        guard let repos: [DBMNewsRepo] = try? LKRoot.root_db?.getObjects(on: [DBMNewsRepo.Properties.link, DBMNewsRepo.Properties.sort_id, DBMNewsRepo.Properties.content],
                                                                         fromTable: "LKNewsRepos",
                                                                         orderBy: [DBMNewsRepo.Properties.sort_id.asOrder(by: .ascending)]) else {
            print("[E] 无法从 LKNewsRepos 中获得数据，终止同步。")
            CallB(operation_result.failed.rawValue)
            return
        }
        // 重置内存数据
        LKRoot.container_news_repo.removeAll()
        for item in repos where item.link != nil {
            let new = DMNewsRepo()
            if item.link!.hasSuffix("/") {
                new.link = item.link!
            } else {
                new.link = item.link! + "/"
            }
            // 下载数据 丢弃所有下载失败的源数据。
            let net_semaphore = DispatchSemaphore(value: 0)
            if let request_url = URL(string: (new.link + "Info")) {
                AF.request(request_url).response(queue: LKRoot.queue_alamofire) { (respond) in
                    switch respond.result {
                    case .success:
                        if respond.data == nil {
                            item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n".localized()
                            print("[E] 无法解压下载的 Info 数据，丢弃")
                        }
                        // 开始解码
                        var read: String?
                        read = String(data: respond.data!, encoding: .utf8)
                        if read == nil {
                            read = String(data: respond.data!, encoding: .ascii)
                        }
                        if read == nil {
                            item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n"
                            print("[E] 无法解压下载的 Info 数据，丢弃")
                        } else {
                            item.content = read
                        }
                    default:
                        // 无法合成下载链接，丢弃数据
                        item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n"
                    } // switch
                    net_semaphore.signal()
                } // AF
            } else {
                // 无法合成下载链接，丢弃数据
                item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n"
            }
            net_semaphore.wait()
            // 更新数据库
            let new_update = DBMNewsRepo()
            new_update.content = item.content
            try? LKRoot.root_db?.update(table: "LKNewsRepos",
                                        on: [DBMNewsRepo.Properties.content],
                                        with: new_update,
                                        where: DBMNewsRepo.Properties.link == item.link!)
            // 解包
            NP_content_invoker(content_str: item.content!, target_RAM: new)
            // 放内存
            LKRoot.container_news_repo.append(new)
            // 下载卡片内容
            var dl_url = new.link
            var got_a_link = false
            for item in Locale.preferredLanguages {
                let read = item.split(separator: "-")[0].to_String() + "-" + item.split(separator: "-")[1].to_String()
                if new.language.contains(read) {
                    got_a_link = true
                    dl_url += read
                    break
                }
            }
            if !got_a_link {
                dl_url += "base"
            }
            // 下载卡片内容
            
        } // for
        CallB(operation_result.success.rawValue)
    } // NP_sync_and_download

    func NP_content_invoker(content_str: String, target_RAM: DMNewsRepo) {
        for_sign: for line in content_str.split(separator: "\n") {
            // 写入可写属性
            var read_opt: String?
            // 分离诸注释
            if line.contains("#") {
                read_opt = line.split(separator: "#").first?.to_String()
                if read_opt == "" || read_opt == nil || line.to_String().hasPrefix("#") {
                    continue for_sign
                }
            } else {
                read_opt = line.to_String()
            }
            // 取头和身子
            var sp_read = (read_opt ?? "").split(separator: "|")
            if sp_read.count < 3 {
                // 无效行，丢弃 ouo
                continue for_sign
            }
            var name: String = sp_read.first?.to_String() ?? ""
            var body: String = ""
            for i in 3...sp_read.count {
                body += sp_read[i - 1] + "\n"
            }
            body = body.dropLast().to_String()
            name = name.drop_space()
            body = body.drop_space()
            // 写入数据咯
            switch name {
            case "LKRP-NAME": target_RAM.name = body
            case "LKRP-PROVIDE-LANGUAGE":
                target_RAM.language.removeAll()
                for language in body.split(separator: ",") {
                    target_RAM.language.append(language.to_String())
                }
            case "LKRP-ICON": target_RAM.icon = body
            case "LKRP-TITLE": target_RAM.title = body
            case "LKRP-SUBTITLE": target_RAM.sub_title = body
            case "LKRP-TITLE-COLOR": target_RAM.title_color = body
            case "LKRP-SUBITLE-COLOR": target_RAM.subtitle_color = body
            default: print("[?] 这啥玩意？" + name)
            }
        }
    }
    
}

