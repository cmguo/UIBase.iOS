//
//  TextAppearance.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation


public class TextAppearance {
    
    public var textColors = StateListColor.bluegrey_900_disabled
    public var textSize: CGFloat = 16
    public var textWeight: UIFont.Weight = .regular
    
    public var font: UIFont {
        return UIFont.systemFont(ofSize: textSize, weight: textWeight)
    }
    
    public var textColor: UIColor {
        return textColors.normalColor()
    }
    
    public init() {}
    
    public init(copy: TextAppearance) {
        textColors = copy.textColors
        textSize = copy.textSize
        textWeight = copy.textWeight
    }
    
    public func textColors(_ colors: StateListColor) -> TextAppearance {
        textColors = colors
        return self
    }
    
    public func textColor(_ color: UIColor) -> TextAppearance {
        textColors = StateListColor(singleColor: color)
        return self
    }
    
    public func textWeight(_ weight: UIFont.Weight) -> TextAppearance {
        textWeight = weight
        return self
    }
    
    public func textSize(_ size: CGFloat) -> TextAppearance {
        textSize = size
        return self
    }
    
}

