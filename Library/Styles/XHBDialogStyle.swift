//
//  XHBDialogStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/27.
//

import Foundation

public class XHBDialogStyle : UIViewStyle {
    
    public var width: CGFloat = 296
    public var borderRadius: CGFloat = 8
    public var paddingX: CGFloat = 24
    public var closePadding: CGFloat = 12
    public var imagePadding: CGFloat = 32
    public var titlePadding: CGFloat = 24 // with image
    public var subTitlePadding: CGFloat = 0
    public var subTitlePadding2: CGFloat = 8 // with image
    public var contentPadding: CGFloat = 16
    public var buttonWidth: CGFloat = 116
    public var buttonPadding: CGFloat = 6
    public var buttonPadding2: CGFloat = 24 // with content
    public var checkBoxPadding: CGFloat = 22
    public var bottomPadding: CGFloat = 24
    public var textAppearance = TextAppearance.Head2
    public var textAppearance2 = TextAppearance.Body_Middle
    public var moreButtonApperance = XHBButtonAppearance(type: .textLink, size: .middle)

    public override init() {
        super.init()
        moreButtonApperance.typeStyle.textColor = .bluegrey_900_selected_disabled
        moreButtonApperance.sizeStyle.height = 48
        moreButtonApperance.sizeStyle.radius = 0
    }
}
