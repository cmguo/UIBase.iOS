//
//  XHBActivityViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation

public class XHBActivityViewStyle : UIViewStyle {
    
    public var itemWidth: CGFloat = 56
    public var itemPaddingX: CGFloat = 16
    public var itemPaddingY: CGFloat = 12
    public var itemPadding: CGFloat = 2
    public var buttonApperance = XHBButtonAppearance(type: .textLink, size: .thin)

    public override init() {
        super.init()
        buttonApperance.typeStyle.textColor = StateListColor(singleColor: .bluegrey_700)
        buttonApperance.typeStyle.iconPosition = .Top
        buttonApperance.sizeStyle.height = 66
        buttonApperance.sizeStyle.textSize = 12
        buttonApperance.sizeStyle.iconSize = 40
        buttonApperance.sizeStyle.iconPadding = 8
    }

}
