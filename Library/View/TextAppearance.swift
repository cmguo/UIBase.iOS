//
//  TextAppearance.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public class TextStyle {
    
    public var textSize: CGFloat = 16
    public var textWeight: UIFont.Weight = .regular
    public var lineHeight: CGFloat = 0
    public var lineSpacing: CGFloat = 0
    public var textAlignment: NSTextAlignment? = nil

    public init() {}
    
    public init(copy: TextStyle) {
        textSize = copy.textSize
        textWeight = copy.textWeight
        lineHeight = copy.lineHeight
        lineSpacing = copy.lineSpacing
        textAlignment = copy.textAlignment
    }
    
    public var font: UIFont {
        return UIFont.systemFont(ofSize: textSize, weight: textWeight)
    }
    
    public func textWeight(_ weight: UIFont.Weight) -> Self {
        textWeight = weight
        return self
    }
    
    public func textSize(_ size: CGFloat) -> Self {
        textSize = size
        return self
    }
    
    public func lineHeight(_ height: CGFloat) -> Self {
        lineHeight = height
        return self
    }
    
    public func lineSpacing(_ spacing: CGFloat) -> Self {
        lineSpacing = spacing
        return self
    }
    
    public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

}

public class TextAppearance : TextStyle {
    
    public var textColors = StateListColor.bluegrey_900_disabled
    public var backgroundColors = StateListColor.transparent_checked_disabled

    public var textColor: UIColor {
        return textColors.normalColor()
    }
    
    public var backgroundColor: UIColor {
        return backgroundColors.normalColor()
    }
    
    public override init() { super.init() }
    
    public init(copy: TextAppearance) {
        super.init(copy: copy)
        textColors = copy.textColors
    }
    
    public init(style: TextStyle, textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        super.init(copy: style)
        if let color = textColor {
            textColors = StateListColor(singleColor: color)
        }
        if let color = backgroundColor {
            backgroundColors = StateListColor(singleColor: color)
        }
    }
    
    public init(style: TextStyle, textColors: StateListColor? = nil, backgroundColors: StateListColor? = nil) {
        super.init(copy: style)
        if let colors = textColors {
            self.textColors = colors
        }
        if let colors = backgroundColors {
            self.backgroundColors = colors
        }
    }
    
    public func textColors(_ colors: StateListColor) -> Self {
        textColors = colors
        return self
    }
    
    public func textColor(_ color: UIColor) -> Self {
        textColors = StateListColor(singleColor: color)
        return self
    }
    
    public func backgroundColors(_ colors: StateListColor) -> Self {
        backgroundColors = colors
        return self
    }
    
    public func backgroundColor(_ color: UIColor) -> Self {
        backgroundColors = StateListColor(singleColor: color)
        return self
    }

}

