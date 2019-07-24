//
//  LKDaemonMonitor.swift
//  Saily
//
//  Created by Lakr Aream on 2019/7/24.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import JJFloatingActionButton

class LKDaemonMonitor: UIViewController {
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = LKRoot.ins_color_manager.read_a_color("main_background")
        
        textView.backgroundColor = .clear
        textView.font = .boldSystemFont(ofSize: 18)
        textView.isEditable = false
        textView.textColor = LKRoot.ins_color_manager.read_a_color("main_text")
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (x) in
            x.edges.equalTo(self.view.snp.edges)
        }
        
        updateText()
        
    }
    
    var checkTimeOut = 256 // like some 60s?
    func updateText(round: Int = 0) {
        let str = (try? String(contentsOfFile: LKRoot.root_path! + "/daemon.call/out.txt")) ?? ""
        if str.contains("Saily::internal_session_finished::Signal") && round < checkTimeOut {
            exitCall()
            return
        }
        if round == checkTimeOut {
            presentStatusAlert(imgName: "Warning", title: "⚠️", msg: "执行任务的时间超出了预期\n你可以选择手动退出")
            exitCall(isTimeOut: true)
        }
        textView.scrollToBottom()
        textView.text = str
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.233) {
            self.updateText(round: round + 1)
        }
    }
    
    func exitCall(isTimeOut: Bool = false) {
        
        let actionButton = JJFloatingActionButton()
        actionButton.addItem(title: "退出".localized(), image: UIImage(named: "Exit"), action: { (_) in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            let alert = UIAlertController(title: "注销？".localized(), message: "几乎所有的插件都需要注销才能被加载".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "执行".localized(), style: .default, handler: { (_) in
                LKDaemonUtils.daemon_msg_pass(msg: "init:req:reSpring")
            }))
            alert.addAction(UIAlertAction(title: "取消".localized(), style: .cancel, handler: { (_) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        })
        actionButton.setRadiusCGF(radius: 22.5)
        actionButton.addShadow(ofColor: LKRoot.ins_color_manager.read_a_color("shadow"))
        var bak_color = LKRoot.ins_color_manager.read_a_color("main_tint_color")
        if LKRoot.settings?.use_dark_mode ?? false {
            bak_color = bak_color.darken(by: 0.5)
        }
        actionButton.backgroundColor = bak_color
        actionButton.buttonColor = bak_color
        view.addSubview(actionButton)
        view.bringSubviewToFront(actionButton)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            actionButton.imageView.snp.remakeConstraints({ (x) in
                x.edges.equalTo(actionButton.snp.edges).inset(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
            })
            actionButton.snp.remakeConstraints({ (x) in
                x.right.equalTo(self.view.snp.right).offset(-18)
                x.bottom.equalTo(self.view.snp.bottom).offset(0 - self.view.safeAreaInsets.bottom - 18)
                x.height.equalTo(45)
                x.width.equalTo(45)
            })
            
        }
        
    }
    
}
