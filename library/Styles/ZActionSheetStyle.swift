//
//  ZActionSheetStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

public class ZActionSheetStyle : UIViewStyle {
    
    public var maxHeight: CGFloat = 360
    public var paddingY: CGFloat = 12
    public var iconSize: CGFloat = 40
    public var iconPadding: CGFloat = 24
    public var titlePadding: CGFloat = 12
    public var textAppearance = TextAppearance.Head3
    public var textAppearance2 = TextAppearance.Body_Small
    public var buttonApperance = ZButtonAppearance(type: .textLink, size: .middle)

    public override init() {
        super.init()
        buttonApperance.typeStyle.textColor = .bluegrey_900_selected_disabled
        buttonApperance.sizeStyle.height = 44
        buttonApperance.sizeStyle.radius = 0
    }
}
