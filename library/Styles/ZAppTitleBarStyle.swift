//
//  ZAppTitleBarStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public class ZAppTitleBarStyle : UIViewStyle {
    
    public var height: CGFloat = 48
    public var padding: CGFloat = 16
    public var iconPadding: CGFloat = 12
    public var buttonPadding: CGFloat = 12
    public var textPadding: CGFloat = 20
    public var textAppearance = TextAppearance.Head2
    public var textAppearanceLarge = TextAppearance.Head1
    public var buttonApperance = ZButtonAppearance(type: .textLinkAppearance, size: .thinAppearance)

    public override init() {
        super.init()
        backgroundColor = .white
        buttonApperance.typeStyle.textColor = StateListColor(singleColor: .bluegrey_800)
        buttonApperance.sizeStyle.iconSize = 20
        buttonApperance.sizeStyle.iconPadding = 5
    }
}

