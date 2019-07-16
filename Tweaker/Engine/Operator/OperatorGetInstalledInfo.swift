//
//  OperatorGetInstalledInfo.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

extension app_opeerator {
    
    // YA means 已安装 Yi An Zhuang
    // Because when I tried to use AI or II or sth like that,
    // It always like fucked by ilIL1
    // Thanks for understanding
    
    func YA_sync_dpkg_info() {
        try? FileManager.default.removeItem(atPath: LKRoot.root_path! + "/dpkg")
        try? FileManager.default.copyItem(atPath: "/Library/dpkg", toPath: LKRoot.root_path! + "/dpkg")
        try? FileManager.default.copyItem(atPath: "/Library/dpkg/status", toPath: LKRoot.root_path! + "/dpkg/status")
    }
    
    func YA_build_installed_list(session: String, _ CallB: @escaping (Int) -> Void) {
        YA_sync_dpkg_info()
        // 尝试从存档获取
        // 如果失败那尝试从原始文件获取
        var read_status = (try? String(contentsOfFile:  LKRoot.root_path! + "/dpkg/status")) ?? "ERR_READ"
        if read_status == "ERR_READ" {
            read_status = (try? String(contentsOfFile:  "/Library/dpkg/status")) ?? "ERR_READ"
        }
        if read_status == "ERR_READ" {
            CallB(operation_result.failed.rawValue)
            return
        }
        
        LKRoot.container_string_store["STR_SIG_PROGRESS"] = "正在刷新软件包列表，这可能需要一些时间。".localized()
        if LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE"] == "TRUE" || session != LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE_SESSION"] {
            return
        }
        LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE"] = "TRUE"
        
        print("[*] 开始更新已安装")
        
        var package = [String : DBMPackage]()
        let read_db: [DBMPackage]? = try? LKRoot.root_db?.getObjects(fromTable: common_data_handler.table_name.LKRecentInstalled.rawValue)
        for item in read_db ?? [] {
            package[item.id] = item
            item.version.removeAll()
            item.signal = "BEGIN_UPDATE"
        }
        
        // 获取时间
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let now = formatter.string(from: date)
        
        let update_sig = DBMPackage()
        update_sig.signal = "BEGIN_UPDATE"
        try? LKRoot.root_db?.update(table: common_data_handler.table_name.LKRecentInstalled.rawValue,
                                    on: [DBMPackage.Properties.signal],
                                    with: update_sig)
        
        
        var read_in = read_status.cleanRN()
        read_in.append("\n\n")
        // 进行解包
        do {
            // 临时结构体
            var info_head = ""
            var info_body = ""
            var in_head = true
            var line_break = false
            var has_a_maohao = false
            var this_package = [String : String]()
            // 开始遍历数据
            for char in read_in {
                let c = char.description
                inner: if c == ":" {
                    line_break = false
                    in_head = false
                    if has_a_maohao {
                        info_body += ":"
                    } else {
                        has_a_maohao = true
                    }
                } else if c == "\n" {
                    if line_break == true {
                        // 两行空行，新数据包 判断软件包是否存在 如果存在则更新version字段
                        if this_package["PACKAGE"] == nil || YA_package_in_exclude_list(id: this_package["PACKAGE"]!) {
                            //                            print("[*] 丢弃没有id的软件包")
                        } else if package[this_package["PACKAGE"]!] != nil {
                            // 存在软件包
                            // 直接添加 version 不检查 version 是否存在因为它不存在就奇怪了
                            let v1 = ["LOCAL": this_package] // 【软件源地址 ： 【属性 ： 属性值】】
                            package[this_package["PACKAGE"]!]!.version[this_package["VERSION"] ?? "0"] = v1
                            // 因为存在软件包 所以我们更新一下 SIG 字段
                            package[this_package["PACKAGE"]!]!.signal = ""
                            package[this_package["PACKAGE"]!]!.one_of_the_package_name_lol = this_package["NAME"] ?? ""
                        } else {
                            // 不存在软件包 创建软件包
                            let new = DBMPackage()
                            new.id = this_package["PACKAGE"]!
                            // latest_update_time 我们去写入数据库的时候更新
                            let v1 = ["LOCAL": this_package] // 【软件源地址 ： 【属性 ： 属性值】】
                            new.version[this_package["VERSION"] ?? "0"] = v1
                            new.one_of_the_package_name_lol = this_package["NAME"] ?? ""
                            new.latest_update_time = now
                            package[this_package["PACKAGE"]!] = new
                        }
                        this_package = [String : String]()
                        has_a_maohao = false
                        break inner
                    }
                    line_break = true
                    in_head = true
                    if info_head == "" || info_body == "" {
                        has_a_maohao = false
                        break inner
                    }
                    while info_head.hasPrefix("\n") {
                        info_head = String(info_head.dropFirst())
                    }
                    info_body = String(info_body.dropFirst())
                    while info_body.hasPrefix(" ") {
                        info_body = String(info_body.dropFirst())
                    }
                    this_package[info_head.uppercased()] = info_body
                    info_head = ""
                    info_body = ""
                    if in_head {
                        info_head += c
                    }
                } else {
                    line_break = false
                    if in_head {
                        info_head += c
                    } else {
                        info_body += c
                    }
                }
            }
            
        } // do
        
        for item in package where item.value.signal != "BEGIN_UPDATE" {
            item.value.signal = "LOCAL"
        }
        
        // 写入更新
        if LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE_SESSION"] != session {
            return
        }
        for key_pair_value in package  {
            try? LKRoot.root_db?.insertOrReplace(objects: key_pair_value.value, intoTable: common_data_handler.table_name.LKRecentInstalled.rawValue)
        }
        // 删除全部没有找到的软件包
        try? LKRoot.root_db?.delete(fromTable: common_data_handler.table_name.LKRecentInstalled.rawValue,
                                    where: DBMPackage.Properties.signal == "BEGIN_UPDATE")
        
        // 重新读取带有最后更新时间数据的数据 lololololol
        let read_again: [DBMPackage]? = try? LKRoot.root_db?.getObjects(fromTable: common_data_handler.table_name.LKRecentInstalled.rawValue)
        package.removeAll()
        for item in read_again ?? [] {
            package[item.id] = item
        }
        LKRoot.container_packages_installed_DBSync = package
        
        LKRoot.container_string_store["IN_PROGRESS_INSTALLED_PACKAGE_UPDATE"] = "FALSE"
        
        LKRoot.manager_reg.ya.re_sync()
        if LKRoot.manager_reg.ya.initd {
            DispatchQueue.main.async {
                LKRoot.manager_reg.ya.update_user_interface {
                    
                }
            }
        }
        
        print("[*] 更新已安装完成")
        CallB(operation_result.success.rawValue)
    }
    
    func YA_package_in_exclude_list(id: String) -> Bool {
        return EXCLUDE_INSTALLED_LIST.contains(id)
    }
    
}

// swiftlint:disable:next private_over_fileprivate
fileprivate let EXCLUDE_INSTALLED_LIST = [
    "gsc.3-gvenice", "gsc.64-bit", "gsc.720p", "gsc.a-w-d-l-capability", "gsc.accelerometer", "gsc.accessibility", "gsc.activation-protocol", "gsc.additional-text-tones", "gsc.aggregate-device-photo-zoom-factor", "gsc.aggregate-device-video-zoom-factor", "gsc.air-drop-capability", "gsc.airplay-mirroring", "gsc.all-features", "gsc.allow-you-tube-plugin", "gsc.allow32-bit-apps", "gsc.ambient-light-sensor", "gsc.any-telephony", "gsc.app-capacity-t-v-o-s", "gsc.app-store", "gsc.application-installation", "gsc.arkit", "gsc.arm64", "gsc.armv6", "gsc.armv7", "gsc.armv7s", "gsc.assistant", "gsc.audio-playback-capability", "gsc.auto-focus-camera", "gsc.backlight-capability", "gsc.baseband-class", "gsc.battery-current-capacity", "gsc.blue-light-reduction-supported", "gsc.bluetooth", "gsc.bluetooth-le", "gsc.board-id", "gsc.c-p-u-sub-type", "gsc.c-p-u-type", "gsc.camera-flash", "gsc.camera-front-flash", "gsc.camera-live-effects-capability", "gsc.camera-max-burst-length", "gsc.cellular-data", "gsc.cellular-telephony-capability", "gsc.chip-i-d", "gsc.cloud-photo-library-capability", "gsc.coastline-glow-rendering-capability", "gsc.compass-type", "gsc.contains-cellular-radio", "gsc.continuity-capability", "gsc.core-routine-capability", "gsc.device-class-number", "gsc.device-color", "gsc.device-cover-glass-color", "gsc.device-enclosure-color", "gsc.device-has-aggregate-camera", "gsc.device-housing-color", "gsc.device-launch-time-limit-scale", "gsc.device-prefers-building-strokes", "gsc.device-prefers-procedural-anti-aliasing", "gsc.device-prefers-traffic-alpha", "gsc.device-prefers3-d-building-strokes", "gsc.device-r-g-b-color", "gsc.device-scene-update-time-limit-scale", "gsc.device-supports-a-o-p", "gsc.device-supports-a-s-t-c", "gsc.device-supports-adaptive-maps-u-i", "gsc.device-supports-always-listening", "gsc.device-supports-always-on-compass", "gsc.device-supports-c-c-k", "gsc.device-supports-camera-haptics", "gsc.device-supports-car-integration", "gsc.device-supports-closed-loop-haptics", "gsc.device-supports-crude-prox", "gsc.device-supports-do-not-disturb-while-driving", "gsc.device-supports-enhanced-a-c3", "gsc.device-supports-haptics", "gsc.device-supports-hi-res-buildings", "gsc.device-supports-liquid-detection_-corrosion-mitigation", "gsc.device-supports-maps-blurred-u-i", "gsc.device-supports-navigation", "gsc.device-supports-periodic-a-l-s-updates", "gsc.device-supports-r-g-b10", "gsc.device-supports-si-d-p", "gsc.device-supports-simplistic-road-mesh", "gsc.device-supports-tethering", "gsc.device-supports-webkit", "gsc.device-supports-y-cb-cr10", "gsc.device-supports1080p", "gsc.device-supports3-d-imagery", "gsc.device-supports3-d-maps", "gsc.device-supports4k", "gsc.device-supports720p", "gsc.device-supports9-pin", "gsc.dictation", "gsc.display-mirroring", "gsc.displayport", "gsc.encode-aac", "gsc.encrypted-data-partition", "gsc.f-d-r-sealing-status", "gsc.f-m-f-allowed", "gsc.face-time-back-camera-temporal-noise-reduction-mode", "gsc.face-time-camera-supports-hardware-face-detection", "gsc.face-time-front-camera-temporal-noise-reduction-mode", "gsc.face-time-photos-opt-in", "gsc.fcc-logos-via-software", "gsc.first-party-launch-time-limit-scale", "gsc.forward-camera-capability", "gsc.front-facing-camera", "gsc.front-facing-camera-auto-h-d-r-capability", "gsc.front-facing-camera-burst-capability", "gsc.front-facing-camera-h-d-r-capability", "gsc.front-facing-camera-h-d-r-on-capability", "gsc.front-facing-camera-max-video-zoom-factor", "gsc.front-facing-camera-still-duration-for-burst", "gsc.front-facing-camera-video-capture1080p-max-f-p-s", "gsc.front-facing-camera-video-capture720p-max-f-p-s", "gsc.full-6", "gsc.gamekit", "gsc.gas-gauge-battery", "gsc.gps", "gsc.green-tea", "gsc.gyroscope", "gsc.h-e-v-c-decoder10bit-supported", "gsc.h-e-v-c-decoder8bit-supported", "gsc.h-e-v-c-encoding-capability", "gsc.h264-encoder-capability", "gsc.hardware-keyboard", "gsc.has-baseband", "gsc.has-extended-color-display", "gsc.has-mesa", "gsc.has-p-k-a", "gsc.has-s-e-p", "gsc.has-spring-board", "gsc.has-thin-bezel", "gsc.hd-video-capture", "gsc.hdr-image-capture", "gsc.healthkit", "gsc.hearingaid-audio-equalization", "gsc.hearingaid-low-energy-audio", "gsc.hidpi", "gsc.highest-supported-video-mode", "gsc.home-button-type", "gsc.homescreen-wallpaper", "gsc.hw-encode-snapshots", "gsc.i-a-p2-capability", "gsc.i-d-a-m-capability", "gsc.image4-supported", "gsc.international-settings", "gsc.io-surface-backed-images", "gsc.is-large-format-phone", "gsc.is-pwr-opposed-vol", "gsc.is-u-i-build", "gsc.launch-time-limit-scale-supported", "gsc.load-thumbnails-while-scrolling", "gsc.location-reminders", "gsc.location-services", "gsc.magnetometer", "gsc.main-screen-class", "gsc.main-screen-height", "gsc.main-screen-pitch", "gsc.main-screen-scale", "gsc.main-screen-width", "gsc.max-h264-playback-level", "gsc.maximum-screen-scale", "gsc.metal", "gsc.microphone", "gsc.microphone-count", "gsc.mix-and-match-prevention", "gsc.mms", "gsc.multitasking", "gsc.music-store", "gsc.n-f-c-radio-calibration-data-present", "gsc.navajo-fusing-state", "gsc.nfc", "gsc.offline-dictation-capability", "gsc.open-g-l-e-s-version", "gsc.opengles-1", "gsc.opengles-2", "gsc.opengles-3", "gsc.panorama-camera-capability", "gsc.peer-peer", "gsc.personal-hotspot", "gsc.phosphorus-capability", "gsc.photo-adjustments", "gsc.photo-capability", "gsc.photo-sharing-capability", "gsc.photo-stream", "gsc.photos-post-effects-capability", "gsc.pipelined-still-image-processing-capability", "gsc.proximity-sensor", "gsc.ptp-large-files", "gsc.r-f-exposure-separation-distance", "gsc.rear-camera-capability", "gsc.rear-facing-camera", "gsc.rear-facing-camera-auto-h-d-r-capability", "gsc.rear-facing-camera-burst-capability", "gsc.rear-facing-camera-h-d-r-capability", "gsc.rear-facing-camera-h-d-r-on-capability", "gsc.rear-facing-camera-h-f-r-capability", "gsc.rear-facing-camera-h-f-r-video-capture1080p-max-f-p-s", "gsc.rear-facing-camera-h-f-r-video-capture720p-max-f-p-s", "gsc.rear-facing-camera-max-video-zoom-factor", "gsc.rear-facing-camera-still-duration-for-burst", "gsc.rear-facing-camera-video-capture-f-p-s", "gsc.rear-facing-camera-video-capture1080p-max-f-p-s", "gsc.rear-facing-camera-video-capture4k-max-f-p-s", "gsc.rear-facing-camera-video-capture720p-max-f-p-s", "gsc.rear-facing-camera60fps-video-capture-capability", "gsc.rear-facing-telephoto-camera-capability", "gsc.regional-behavior-china-brick", "gsc.regional-behavior-g-b18030", "gsc.regional-behavior-valid", "gsc.render-wide-gamut-images-at-display-time", "gsc.ringer-switch", "gsc.screen-recorder-capability", "gsc.secure-element", "gsc.shoebox", "gsc.signing-fuse", "gsc.siri-gesture", "gsc.siri-offline-capability", "gsc.sms", "gsc.sphere-capability", "gsc.stand-alone-contacts", "gsc.stark-capability", "gsc.still-camera", "gsc.supports-force-touch", "gsc.supports-iris-capture", "gsc.supports-low-power-mode", "gsc.supports-rotate-to-wake", "gsc.supports-s-o-s", "gsc.supports-s-s-h-b-button-type", "gsc.telephony", "gsc.touch-id", "gsc.tv-out-crossfade", "gsc.u-i-background-quality", "gsc.u-i-parallax-capability", "gsc.u-i-procedural-wallpaper-capability", "gsc.u-i-reachability", "gsc.unified-ipod", "gsc.venice", "gsc.vibrator-capability", "gsc.video-camera", "gsc.video-stills", "gsc.voice-control", "gsc.voip", "gsc.volume-buttons", "gsc.w-a-graphic-quality", "gsc.w-l-a-n-bkg-scan-cache", "gsc.wapi", "gsc.watch-companion", "gsc.wi-fi", "gsc.wifi", "gsc.wifi-chipset", "gsc.youtube-plugin", "cy+cpu.arm64", "cy+kernel.darwin", "cy+lib.corefoundation", "cy+model.iphone", "cy+os.ios", "gsc.battery-is-charging", "gsc.camera-h-d-r2-capability", "gsc.device-corner-radius", "gsc.device-requires-proximity-ameliorations", "gsc.device-supports-e-label", "gsc.device-supports-portrait-light-effect-filters", "gsc.device-supports-tap-to-wake", "gsc.device-supports-tone-mapping", "gsc.external-power-source-connected", "gsc.h-e-v-c-decoder12bit-supported", "gsc.hall-effect-sensor", "gsc.has-battery", "gsc.o-l-e-d-display", "gsc.pearl-i-d-capability", "gsc.si-k-a-capability", "gsc.supports-burnin-mitigation", "gsc.touch-delivery120-hz", "gsc.wireless-charging-capability"]
