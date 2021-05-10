//
//  XHBListViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation

public class XHBListViewStyle : UIViewStyle {
    
    public var itemStyle = XHBListItemStyle()

    public override init() {
        super.init()
    }
}

public class XHBListItemStyle : UIViewStyle {
    
    public var height: CGFloat = 48
    public var height2: CGFloat = 72
    public var paddingX: CGFloat = 16
    public var subTextPadding: CGFloat = 16
    public var textAppearance = TextAppearance.Body_Middle
    public var subTextAppearance = TextAppearance.Secondary
    public var iconSize: CGFloat = 18
    public var iconPadding: CGFloat = 4
    public var iconSize2: CGFloat = 40
    public var iconPadding2: CGFloat = 8

    public var buttonAppearence = XHBButtonAppearance(type: XHBButtonTypeStyle(textColor: .bluegrey_700_disabled, backgroundColor: .clear, iconPosition: .Right), size: .middle)

    public var textFieldStyle = XHBTextFieldStyle()
    
    public override init() {
        super.init()
        buttonAppearence.sizeStyle.padding = 0
        buttonAppearence.sizeStyle.radius = 0
    }
    
}
