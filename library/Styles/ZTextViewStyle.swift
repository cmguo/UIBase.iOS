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
    public var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    public var buttonAppearance = ZButtonAppearance(
        type: .init(textColor: .red_600_disabled, backgroundColor: .clear),
        size: .init(height: 32, radius: 0, padding: 5, textSize: 10, iconSize: 12, iconPadding: 0))

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
