//
//  ZTextAppearance.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public extension TextStyle {
    
    static let Title = TextAppearance().textWeight(.bold)
    static let Title_24 = TextAppearance(copy: .Title).textSize(24).lineHeight(36)
    static let Title_20 = TextAppearance(copy: .Title).textSize(20).lineHeight(32)
    static let Title_18 = TextAppearance(copy: .Title).textSize(18).lineHeight(28)
    static let Title_16 = TextAppearance(copy: .Title).textSize(16).lineHeight(24)
    static let Title_14 = TextAppearance(copy: .Title).textSize(14).lineHeight(20)

    static let Body = TextAppearance()
    static let Body_18 = TextAppearance(copy: .Body).textSize(18).lineHeight(28)
    static let Body_16 = TextAppearance(copy: .Body).textSize(16).lineHeight(24)
    static let Body_14 = TextAppearance(copy: .Body).textSize(14).lineHeight(20)
    static let Body_12 = TextAppearance(copy: .Body).textSize(12).lineHeight(20)
    static let Body_10 = TextAppearance(copy: .Body).textSize(10).lineHeight(20)

}

public extension TextAppearance {
    
    static let Head = Title
    static let Head0 = Title_24
    static let Head1 = Title_20
    static let Head2 = Title_18
    static let Head3 = Title_16
    static let Head4 = TextAppearance(style: .Title_14, textColors: .bluegrey_800_disabled)

    static let Body_Large = Body_18
    static let Body_Middle = Body_16
    static let Body_Small = Body_14

    static let Body_Secondary = TextAppearance(style: .Body_12, textColor: .bluegrey_700)
    static let Body_Tip = TextAppearance(style: .Body_10, textColor: .bluegrey_700)

}

