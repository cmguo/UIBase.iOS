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
    public var buttonAppearance = ZButtonAppearance(.textLinkThin,
                                                      textColor: StateListColor(singleColor: .bluegrey_800),
                                                      iconSize: 20,
                                                      iconPadding: 5)

    public override init() {
        super.init()
        backgroundColor = .bluegrey_00
    }
}

