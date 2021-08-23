//
//  ZTextFieldStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/2.
//

import Foundation

public class ZTextFieldStyle : UITextFieldStyle {
    
    public var height: CGFloat = 32

    public var buttonAppearance = ZButtonAppearance(
        textColor: .red_600_disabled, backgroundColor: .clear,
        minHeight: 32, cornerRadius: 0, paddingX: 5, paddingY: 0, textSize: 10, iconSize: 12, iconPadding: 0)

    public override init() {
        super.init()
        backgroundColors = StateListColor([
            StateColor(.bluegrey_100, .disabled),
            StateColor(.bluegrey_00, .normal)
        ])
        cornerRadius = 8
        borderWidth = 1
        borderColors = StateListColor([
            StateColor(.red_500, .error),
            StateColor(.blue_600, .focused),
            StateColor(.bluegrey_300, .normal)
        ])
        
        textAppearance = .body_middle
    }
    
    
}
