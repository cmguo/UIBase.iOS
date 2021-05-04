//
//  ZNumberViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/1.
//

import Foundation

public class ZNumberViewStyle : UIViewStyle {
    
    public var size = CGSize(width: 108, height: 32)
    public var padding: CGFloat = 1
    public var textAppearance = TextAppearance.Body_Middle
    public var buttonAppearance = ZButtonAppearance(
        type: .init(textColor: .bluegrey_900_disabled2, backgroundColor: .init(singleColor: .bluegrey_00)),
        size: .init(height: 30, radius: 15, padding: 3, textSize: 22, iconSize: 24, iconPadding: 0))
        
    public override init() {
        super.init()
        backgroundColor = .bluegrey_100
        cornerRadius = 16
    }
    
}
