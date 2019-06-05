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
                print("[*] 准备从 " + request_url.absoluteString + " 请求数据。")
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
                            item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n".localized()
                            print("[E] 无法解压下载的 Info 数据，丢弃")
                        } else {
                            item.content = read
                        }
                    default:
                        // 无法合成下载链接，丢弃数据
                        item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n".localized()
                    } // switch
                    net_semaphore.signal()
                } // AF
            } else {
                // 无法合成下载链接，丢弃数据
                item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n".localized()
            }
            var signal_ed_62 = false
            LKRoot.queue_dispatch.async {
                sleep(UInt32(LKRoot.settings?.network_timeout ?? 6))
                if signal_ed_62 {
                    return
                }
                item.content = "LKRP-TITLE| |加载失败\nLKRP-SUBTITLE| |请重试\n".localized()
                net_semaphore.signal()
                print("[*] 网络数据超时，放弃数据。")
            }
            net_semaphore.wait()
            signal_ed_62 = true
            // 更新数据库
            let new_update = DBMNewsRepo()
            new_update.content = item.content
            try? LKRoot.root_db?.update(table: "LKNewsRepos",
                                        on: [DBMNewsRepo.Properties.content],
                                        with: new_update,
                                        where: DBMNewsRepo.Properties.link == item.link!)
            // 解包
            NP_content_invoker(content_str: item.content ?? "", target_RAM: new)
            // 下载卡片内容
            var dl_url_str = new.link
//            var got_a_link = false
//            for_preferred_languages: for item in Locale.preferredLanguages {
//                if item.split(separator: "-").count < 2 {
//                    print("[Resumable - fatalError] for_preferred_languages - split.count < 2 - DATA: " + item)
//                    continue for_preferred_languages
//                }
//                let read = item.split(separator: "-")[0].to_String() + "-" + item.split(separator: "-")[1].to_String()
//                if new.language.contains(read) {
//                    got_a_link = true
//                    dl_url_str += read
//                    break
//                }
//            }
//            if !got_a_link {
                dl_url_str += "Base"
//            }
            // 下载卡片内容
            var read_cards: String?
            let net_semaphore_2 = DispatchSemaphore(value: 0)
            if let dl_url = URL(string: dl_url_str) {
                print("[*] 准备从 " + dl_url.absoluteString + " 请求数据。")
                AF.request(dl_url).response { (respond) in
                    if respond.data != nil {
                        read_cards = String(data: respond.data!, encoding: .utf8)
                        if read_cards == nil {
                            read_cards = String(data: respond.data!, encoding: .ascii)
                        }
                        if read_cards == nil {
                            read_cards = """
                            --> Begin Card
                            LKCD-TYPE|                                      |photo_half_with_banner_down_light
                            LKCD-TITLE|                                     |无法解析新闻内容|请联系维护者尽快修复
                            LKCD-SUBTITLE|                                  |BAD NETWORK RESULT
                            LKCD-DESSTR|                                    |--- ERROR ---
                            LKCD-PHOTO|                                     |LKINTERNAL-ERROR-LOAD
                            
                            LKCD-TITLE-COLOR|                               |0x000000
                            LKCD-SUBTITLE-COLOR|                            |0x0AAADD
                            LKCD-DESSTR-COLOR|                              |0x999999
                            
                            ---> End Card
                            """.localized()
                        }
                    }
                    net_semaphore_2.signal()
                }
            } else {
                // 无法合成下载链接，丢弃数据
            }
            var signal_ed_130 = false
            LKRoot.queue_dispatch.async {
                sleep(UInt32(LKRoot.settings?.network_timeout ?? 6))
                if signal_ed_130 {
                    return
                }
                read_cards = """
                --> Begin Card
                LKCD-TYPE|                                      |photo_half_with_banner_down_light
                LKCD-TITLE|                                     |无法下载新闻内容|请联系维护者尽快修复
                LKCD-SUBTITLE|                                  |BAD NETWORK RESULT
                LKCD-DESSTR|                                    |--- ERROR ---
                LKCD-PHOTO|                                     |LKINTERNAL-ERROR-LOAD
                
                LKCD-TITLE-COLOR|                               |0x000000
                LKCD-SUBTITLE-COLOR|                            |0x0AAADD
                LKCD-DESSTR-COLOR|                              |0x999999
                
                ---> End Card
                """.localized()
                net_semaphore_2.signal()
                print("[*] 网络数据超时，放弃数据。")
            }
            net_semaphore_2.wait()
            signal_ed_130 = true
            new.cards = NP_cards_content_invoker(content_str: read_cards ?? "")
            // 放内存
            LKRoot.container_news_repo.append(new)
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
            let sp_read = (read_opt ?? "").split(separator: "|")
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
    } // NP_content_invoker
    
    func NP_cards_content_invoker(content_str: String) -> [DMNewsCard] {
        
        var ins_card = DMNewsCard()
        var ret = [DMNewsCard]()
        
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
            
            if read_opt!.contains("--> Begin Card") {
                ins_card = DMNewsCard()
                continue for_sign
            }
            
            if read_opt!.contains("---> End Card") {
                ret.append(ins_card)
                continue for_sign
            }
            
            // 取头和身子
            let sp_read = (read_opt ?? "").split(separator: "|")
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
            case "LKCD-TYPE":
                switch body {
                case "photo_full_with_banner_down_dark": ins_card.type = card_type.photo_full_with_banner_down_dark
                case "photo_half_with_banner_down_light": ins_card.type = card_type.photo_half_with_banner_down_light
                case "river_view_animate": ins_card.type = card_type.river_view_animate
                case "river_view_static": ins_card.type = card_type.river_view_static
                default: ins_card.type = card_type.photo_full
                }
            case "LKCD-TITLE": ins_card.main_title_string = body
            case "LKCD-SUBTITLE": ins_card.sub_title_string = body
            case "LKCD-DESSTR": ins_card.description_string = body
            case "LKCD-PHOTO":
                for photo in body.split(separator: ",") {
                    let photo = photo.to_String().drop_space()
                    ins_card.image_container.append(photo)
                }
            case "LKCD-TITLE-COLOR": ins_card.main_title_string_color = body
            case "LKCD-SUBTITLE-COLOR": ins_card.sub_title_string_color = body
            case "LKCD-DESSTR-COLOR": ins_card.description_string_color = body
            case "LKCD-CONTENTS": ins_card.content = body
            default: print("[?] 这啥玩意？" + name)
            }
        }
        return ret
    } // NP_cards_content_invoker
    
    func NP_download_card_contents(target: DMNewsCard, result_str: @escaping (String) -> Void) {
        guard let dl_url = URL(string: target.content ?? "") else {
            print("[Resumable - fatalError] 无法内容创建下载链接。")
            return
        }
        
        let network_semaphore = DispatchSemaphore(value: 0)
        var signaled_here = false
        var ret_str: String?
        
        print("[*] 准备从 " + dl_url.absoluteString + " 请求数据。")
        
        AF.request(dl_url).response(queue: LKRoot.queue_alamofire) { (ret) in
            guard ret.data != nil else {
                print("[Resumable - fatalError] 无下载内容。")
                signaled_here = true
                network_semaphore.signal()
                return
            }
            ret_str = String(data: ret.data!, encoding: .utf8)
            if ret_str == nil {
                ret_str = String(data: ret.data!, encoding: .ascii)
            }
            signaled_here = true
            network_semaphore.signal()
            return
        }
        
        LKRoot.queue_alamofire.async {
            sleep(UInt32(LKRoot.settings?.network_timeout ?? 6))
            if !signaled_here {
                print("[*] 网络数据超时，放弃数据。")
                network_semaphore.signal()
            }
        }
        
        network_semaphore.wait()
        
        if ret_str == "" || ret_str == nil {
            ret_str = "--> Begin Section |text_inherit_saying|错误|\n尝试下载卡片内容失败了。\n---> End Section".localized()
        }
    
        result_str(ret_str ?? "")
        
    } // NP_download_card_contents
    
}

