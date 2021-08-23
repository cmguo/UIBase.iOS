//
//  ZActionSheetStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

public class ZActionSheetStyle : UIViewStyle {
    
    public var maxHeight: CGFloat = 360
    public var paddingY: CGFloat = 14
    public var iconSize: CGFloat = 40
    public var iconPadding: CGFloat = 12
    public var textAppearance = TextAppearance.Head3
    public var textAppearance2 = TextAppearance(copy: .Body_Small).textColor(.bluegrey_700).textAlignment(.center)
    public var buttonApperance = ZButtonAppearance(.textLinkMiddle,
                                                     textColor: .bluegrey_900_selected_disabled,
                                                     height: 44,
                                                     cornerRadius: 0).normalized()

    public override init() {
        super.init()
    }
}
