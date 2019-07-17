//
//  LKPackageWeb.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/7/17.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import WebKit

class LKPackageWeb: UIViewController {
    
    public var item: DBMPackage = DBMPackage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LKRoot.settings?.use_dark_mode ?? false {
            navigationController?.navigationBar.barStyle = .blackOpaque
        } else {
            navigationController?.navigationBar.barStyle = .default
        }
        
    }
    
    
}
