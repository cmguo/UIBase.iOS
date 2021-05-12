//
//  ZTextInputStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

public class ZTextInputStyle : ZTextViewStyle {

    public var buttonAppearance = ZButtonAppearance(
        type: .init(textColor: .red_600_disabled, backgroundColor: .clear),
        size: .init(height: 20, radius: 0, padding: 0, textSize: 0, iconSize: 12, iconPadding: 4))
    public var wordCountLabelAppearance = TextAppearance().textSize(12).textColor(.bluegrey_500)

    public override init() {
        super.init()
    }
    
}
