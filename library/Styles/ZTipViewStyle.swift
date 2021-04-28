//
//  ZTipViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

public class ZTipViewStyle {
    
    public var arrowSize: CGFloat = 6
    public var arrowOffset: CGFloat = 16
    public var radius: CGFloat = 8
    public var paddingX: CGFloat = 16
    public var paddingY: CGFloat = 12
    public var iconSize: CGFloat = 16
    public var iconPadding: CGFloat = 8
    public var frameColor = UIColor(rgb: 0x1D2126)
    public var textColor = UIColor.bluegrey_00
    public var dismissDelay: Double = 3000
    public var textAppearance = TextAppearance(copy: .Body_Middle).textColor(.bluegrey_00)
    public var textAppearanceSmall = TextAppearance(copy: .Body_Small).textColor(.bluegrey_00)
    
    public init() {}
}
