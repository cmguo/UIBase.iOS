//
//  ZDialogStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/27.
//

import Foundation

public class ZDialogStyle : UIViewStyle {
    
    public var width: CGFloat = 296
    public var borderRadius: CGFloat = 8
    public var paddingX: CGFloat = 24
    public var closePadding: CGFloat = 12
    public var topPadding: CGFloat = 16
    public var subTitlePadding: CGFloat = 8
    public var contentPadding: CGFloat = 16
    public var buttonWidth: CGFloat = 116
    public var buttonPadding: CGFloat = 14
    public var buttonPadding2: CGFloat = 24 // with content
    public var checkBoxPadding: CGFloat = 22
    public var bottomPadding: CGFloat = 18
    public var textAppearance = TextAppearance.Head2
    public var textAppearance2 = TextAppearance(copy: .Body_Middle).textAlignment(.center)
    public var moreButtonApperance = ZButtonAppearance(.textLinkMiddle,
                                                         textColor: .bluegrey_900_selected_disabled,
                                                         height: 48,
                                                         cornerRadius: 0).normalized()

    public override init() {
        super.init()
    }
}
