//
//  ZTextViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

public class ZTextViewStyle : UITextViewStyle {
    
    public var placeholderTextColor = UIColor.bluegrey_500
    
    public var minHeight: CGFloat = 32
    public var padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

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
