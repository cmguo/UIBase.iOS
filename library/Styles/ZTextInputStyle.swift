//
//  ZTextInputStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

public class ZTextInputStyle : ZTextViewStyle {

    public var buttonAppearance = ZButtonAppearance(
        textColor: .red_600_disabled, backgroundColor: .clear,
        minHeight: 20, cornerRadius: 0, paddingX: 0, paddingY: 0, textSize: 0, iconSize: 12, iconPadding: 4)
    public var wordCountLabelAppearance = TextAppearance().textSize(12).textColor(.bluegrey_500)

    public override init() {
        super.init()
    }
    
}
