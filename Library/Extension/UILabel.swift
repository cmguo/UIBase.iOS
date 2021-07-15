//
//  UILabel.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

extension UILabel : TextOwner {
    public var attributedText2: NSAttributedString? {
        get { return attributedText }
        set { attributedText = newValue }
    }
    public var text2: String? { return text }
    public var font2: UIFont? { return font }
}
