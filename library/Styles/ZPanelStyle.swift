//
//  XHBPanelStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public class XHBPanelStyle : UIViewStyle {
    
    public var borderRadius: CGFloat = 12
    public var bottomHeight: CGFloat = 48
    public var buttonApperance = XHBAppTitleBarStyle().buttonApperance

    public override init() {
        super.init()
        backgroundColor = .white
    }

}