//
//  ZDropDown.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

public class ZDropDownStyle : UIViewStyle {
    
    public var shadowRadius: CGFloat = 6
    public var borderRadius: CGFloat = 8
    public var maxHeight: CGFloat = 400
    public var itemHeight: CGFloat = 48
    public var itemPaddingX: CGFloat = 16
    public var itemPaddingY: CGFloat = 12
    public var iconSize: CGFloat = 24
    public var iconPadding: CGFloat = 8
    public var textAppearance = TextAppearance.Body_Middle

    public override init() {
        super.init()
    }

}
