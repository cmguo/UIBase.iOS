//
//  ZSearchBarStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation

public class ZSearchBarStyle : UIViewStyle {
    
    public var size = CGSize(width: 108, height: 32)
    public var textAppearance = TextAppearance.body_middle
        
    public override init() {
        super.init()
        backgroundColor = .bluegrey_05
        cornerRadius = 16
    }
    
}
