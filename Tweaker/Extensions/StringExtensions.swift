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
    
}

extension Substring {
    
    func to_String() -> String {
        return String(self)
    }
    
}
