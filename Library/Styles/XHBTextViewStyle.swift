//
//  XHBTextViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

public class XHBTextViewStyle : UITextViewStyle {
    
    public var placeholderTextColor = UIColor.bluegrey_500
    
    public var minHeight: CGFloat = 32
    public var padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    public override init() {
        super.init()
        backgroundColors = StateListColor([
            StateColor(.bluegrey_100, .STATES_DISABLED),
            StateColor(.bluegrey_00, .STATES_NORMAL)
        ])
        cornerRadius = 8
        borderWidth = 1
        borderColors = StateListColor([
            StateColor(.red_500, .STATES_ERROR),
            StateColor(.blue_600, .STATES_FOCUSED),
            StateColor(.bluegrey_300, .STATES_NORMAL)
        ])
        
        textAppearance = .Body_Middle
    }
    
    
}
