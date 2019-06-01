//
//  AppDelegate.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

var is_iPad = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            is_iPad = true
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = #colorLiteral(red: 0.2882809639, green: 0.5985316038, blue: 0.9432967305, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        // Twitter 动画
        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        if is_iPad {
            mainStoryboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        let navigationController = mainStoryboard.instantiateInitialViewController()!
        self.window!.rootViewController = navigationController
        navigationController.twitter_animte()
        
        LKRoot.initializing()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
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
