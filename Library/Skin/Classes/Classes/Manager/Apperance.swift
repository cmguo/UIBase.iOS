//
//  Apperance.swift
//  blackboard
//
//  Created by kingxt on 2017/10/18.
//  Copyright © 2017年 xkb. All rights reserved.
//
//import Core
//import ESTabBarController
import UIKit
import SwiftyJSON

public enum FontType: Int {
    case regular
    case light
    case medium
    case semibold
    case dinbold
}

/* MARK: - 5.0.0 图片读取方法
 * 5.0.0 版本后图片放进新的 bundle
 * 白色皮肤 bundle 名: Default.bundle
 * 黑色皮肤 bundle 名: DarkMode.bundle
 */

public func getImage(_ name: String) -> UIImage? {
    guard !name.isEmpty else {
        return nil
    }
    let bundleName: String = SkinManager.instance.config.currentBundleName.rawValue
    var image = UIImage(named: bundleName + ".bundle/" + name + ".png")
    if image == nil {
        image = UIImage(named: name)
    }
    return image
}

public func systemFontSize(fontSize: CGFloat, type: FontType? = .regular) -> UIFont {
    if #available(iOS 9.0, *) {
        if type == .regular {
            return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        } else if type == .medium {
            return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        } else if type == .semibold {
            return UIFont(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        } else if type == .dinbold {
            return UIFont(name: "DIN-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        } else {
            return UIFont(name: "PingFangSC-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
    } else {
        return UIFont.systemFont(ofSize: fontSize)
    }
}

public func numberFontSize(fontSize: CGFloat) -> UIFont {
    if #available(iOS 9.0, *) {
        return UIFont(name: "DIN-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    return UIFont.systemFont(ofSize: fontSize)
}

public func appendAttributedString(valus: [[String: [NSAttributedString.Key: Any]]]) -> NSMutableAttributedString {
    let string = NSMutableAttributedString()
    valus.forEach { item in
        item.forEach({ key, value in
            string.append(setStyleWithText(text: key, value: value))
        })
    }
    return string
}

public func setStyleWithText(text: String, value: [NSAttributedString.Key: Any]) -> NSAttributedString {
    return NSAttributedString(string: text, attributes: value)
}

public func dinRegularText(text: String, font: UIFont) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: text)
    let numberRegularExpression = try? NSRegularExpression(pattern: "[0-9]", options: .caseInsensitive)
    let numberFont = numberFontSize(fontSize: font.pointSize)
    if let expression = numberRegularExpression {
        let matcher = expression.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        for item in matcher {
            attributedString.addAttribute(NSAttributedString.Key.font, value: numberFont, range: item.range)
        }
    }
    return attributedString
}
