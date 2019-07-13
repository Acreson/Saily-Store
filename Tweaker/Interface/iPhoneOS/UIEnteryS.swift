//
//  UIEntery.swift
//  Tweaker
//
//  Created by Lakr Aream on 2019/5/28.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

class UIEnteryS: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LKRoot.tabbar_view_controller = self
        
        print("[*] 将以 iPhone 的方式加载故事版。")
        
        tabBar.tintColor = LKRoot.ins_color_manager.read_a_color("main_tint_color")
        tabBar.backgroundColor = LKRoot.ins_color_manager.read_a_color("tabbar_background")
        tabBar.barTintColor = LKRoot.ins_color_manager.read_a_color("tabbar_background")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            LKRoot.current_page = self.selectedViewController ?? UIViewController()
        }
        
        let dev = LKRoot.shared_device
        if dev._id_str().contains("iPhone SE") || dev._id_str().contains("iPhone 5") {
            let alert = UIAlertController(title: "警告".localized(), message: "您的设备分辨率太低，这会影响到UI布局。我们不推荐您使用本产品。您可以通过设置页面的高级选项安装Cydia".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "了解".localized(), style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let willing = selectedViewController
        if willing == LKRoot.current_page {
            for this in willing?.view.subviews ?? [] where this as? UIScrollView != nil {
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                    (this as? UIScrollView)?.contentOffset = CGPoint(x: 0, y: -66)
                }, completion: { _ in
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
            }
            return
        }
        LKRoot.current_page = selectedViewController ?? UIViewController()
        
        guard let view = item.value(forKey: "_view") as? UIView else { return }
        for item in view.subviews {
            if let image = item as? UIImageView {
                image.shineAnimation()
                break
            }
        }
    }
    
}
