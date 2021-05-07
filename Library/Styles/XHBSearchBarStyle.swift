//
//  XHBSearchBarStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation

public class XHBSearchBarStyle : UIViewStyle {
    
    public var size = CGSize(width: 108, height: 32)
    public var textAppearance = TextAppearance.Body_Middle
        
    public override init() {
        super.init()
        backgroundColor = .bluegrey_100
        cornerRadius = 16
    }
    
}
