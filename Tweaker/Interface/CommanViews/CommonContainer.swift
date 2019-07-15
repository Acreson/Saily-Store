//
//  UIViewCacheContainer.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//


enum view_tags: Int {
    case must_have                              = 0x101
    case indicator                              = 0x102
    case can_remove                             = 0x103
    case must_remove                            = 0x233
    
    case pop_up                                 = 0x234
    
    case main_scroll_view_in_view_controller    = 0x111
    
}

class common_views {
    // 啥都不用干
}

class manage_views {
    // 啥都不用干
}

class manage_view_reg {
    let nr = manage_views.LKIconGroupDetailView_NewsRepoSP()
    let pr = manage_views.LKIconGroupDetailView_PackageRepoSP()
    let ru = manage_views.LKIconGroupDetailView_RecentUpdate()
    let se = manage_views.LKIconGroupDetailView_Settings()
}

class cell_views {
    // 啥都不用干
}

func presentStatusAlert(imgName: String, title: String, msg: String) {
    if LKRoot.settings?.use_dark_mode ?? false {
        let statusAlert = StatusAlertDark()
        statusAlert.image = UIImage(named: imgName)
        statusAlert.title = title
        statusAlert.message = msg
        statusAlert.canBePickedOrDismissed = true
        statusAlert.showInKeyWindow()
    } else {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(named: imgName)
        statusAlert.title = title
        statusAlert.message = msg
        statusAlert.canBePickedOrDismissed = true
        statusAlert.showInKeyWindow()
    }
}

func presentSwiftMessage(title: String, body: String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureTheme(.success)
    view.configureDropShadow()
    view.configureContent(title: title, body: body)
    view.button?.isHidden = true
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    (view.backgroundView as? CornerRoundingView)?.cornerRadius = CGFloat(LKRoot.settings?.card_radius ?? 8)
    SwiftMessages.show(view: view)
}
