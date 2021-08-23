//
//  UIViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public class UIViewStyle {
    
    public var backgroundColor: UIColor {
        get { backgroundColors.normalColor() }
        set { backgroundColors = StateListColor(singleColor: newValue) }
    }
    public var backgroundColors = StateListColor(singleColor: .clear)
    public var cornerRadius: CGFloat = 0
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor {
        get { borderColors.normalColor() }
        set { borderColors = StateListColor(singleColor: newValue) }
    }
    public var borderColors = StateListColor(singleColor: .clear)

    public init() {
    }
    
    public init(copy: UIViewStyle) {
        borderColors = copy.backgroundColors
        cornerRadius = copy.cornerRadius
        borderWidth = copy.borderWidth
        borderColors = copy.borderColors
    }

    public static let `default` = UIViewStyle()
}
