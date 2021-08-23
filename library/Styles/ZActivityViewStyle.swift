//
//  ZActivityViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation

public class ZActivityViewStyle : UIViewStyle {
    
    public var itemWidth: CGFloat = 56
    public var itemPaddingX: CGFloat = 16
    public var itemPaddingY: CGFloat = 12
    public var itemPadding: CGFloat = 2
    public var buttonApperance = ZButtonAppearance(.textLinkThin,
                                                     textColor: StateListColor(singleColor: .bluegrey_700),
                                                     iconPosition: .top,
                                                     height: 66,
                                                     textSize: 12,
                                                     iconSize: 40,
                                                     iconPadding: 8).normalized()

    public override init() {
        super.init()
    }

}
