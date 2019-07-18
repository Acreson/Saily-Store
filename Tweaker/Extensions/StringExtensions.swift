//
//  String+Extension.swift
//  Saily
//
//  Created by mac on 2019/5/11.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation

extension String {
    
    func readClipBoard() -> String {
        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
            return theString
        }
        return ""
    }
    
    func pushClipBoard() {
        UIPasteboard.general.string = self
    }
    
    func share(from_view: UIView? = nil) {
        let textToShare = [self]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        var some = UIViewController()
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            some = topController
        }
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = from_view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        some.present(activityViewController, animated: true, completion: nil)
    }
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func drop_space() -> String {
        var ret = self
        while ret.hasPrefix(" ") {
            ret = ret.dropFirst().to_String()
        }
        while ret.hasSuffix(" ") {
            ret = ret.dropLast().to_String()
        }
        return ret
    }
    
    func drop_comment() -> String {
        if !self.contains("#") {
            return self
        }
        if self.hasPrefix("#") {
            return ""
        }
        return self.split(separator: "#").first?.to_String() ?? ""
    }
    
    func returnUIHeight(font: UIFont, widthOfView: CGFloat) -> CGFloat {
        let frame = NSString(string: self).boundingRect(
            with: CGSize(width: widthOfView, height: .infinity),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : font],
            context: nil)
        return frame.size.height
    }
    
    func cleanRN() -> String {
        var newString = self.replacingOccurrences(of: "\r\n", with: "\n", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "\r", with: "\n", options: .literal, range: nil)
        return newString
    }
    
}

extension Substring {
    
    func to_String() -> String {
        return String(self)
    }
    
}

extension Collection where Element: Equatable {
    
    func indexDistance(of element: Element) -> Int? {
        guard let index = firstIndex(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
    
}
extension StringProtocol {
    
    func indexDistance(of string: Self) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
    
}
