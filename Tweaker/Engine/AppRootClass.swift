//
//  AppRootClass.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

let LKRoot = app_root_class()

class app_root_class {
    
    var container_cache_uiview = [UIView]()                 // 视图缓存咯
    
    let ins_color_manager = color_sheet()                   // 颜色表 - 以后拿来写主题
    let ins_view_manager = common_views()                   // 视图扩展
    let ins_user_manager = app_user_class()                 // 用户管理
    
    
}



