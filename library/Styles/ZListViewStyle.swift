//
//  ZListViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation

public class ZListViewStyle : UIViewStyle {
    
    public var headerStyle = ZListItemStyle()
    public var itemStyle = ZListItemStyle()

    public override init() {
        super.init()
        headerStyle.height = 36
        headerStyle.paddingX = 0
        headerStyle.textAppearance = TextAppearance(copy: .Body_Secondary).textSize(14)
    }
}

public class ZListItemStyle : UIViewStyle {
    
    public var height: CGFloat = 48
    public var height2: CGFloat = 72
    public var paddingX: CGFloat = 16
    public var subTextPadding: CGFloat = 16
    public var textAppearance = TextAppearance.Body_Middle
    public var subTextAppearance = TextAppearance.Body_Secondary
    public var iconSize: CGFloat = 18
    public var iconPadding: CGFloat = 4
    public var iconSize2: CGFloat = 40
    public var iconPadding2: CGFloat = 8

    public var buttonAppearence = ZButtonAppearance(.middle, textColor: .bluegrey_700_disabled, backgroundColor: .clear, iconPosition: .Right, cornerRadius: 0)

    public var textFieldStyle = ZTextFieldStyle()
    
    public override init() {
        super.init()
        backgroundColor = .bluegrey_00
    }
    
}
