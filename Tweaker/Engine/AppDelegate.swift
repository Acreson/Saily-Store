//
//  AppDelegate.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            LKRoot.is_iPad = true
        }
        
        LKRoot.initializing()
        
        LKDaemonUtils.initializing()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = #colorLiteral(red: 0.2882809639, green: 0.5985316038, blue: 0.9432967305, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        if LKRoot.is_iPad {
            mainStoryboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        let navigationController = mainStoryboard.instantiateInitialViewController()!
        self.window!.rootViewController = navigationController
        
        if LKRoot.ins_color_manager.read_a_color("DARK_ENABLED") == .clear {
            // Twitter 动画
            navigationController.twitter_animte()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        LKRoot.ever_went_background = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
