//
//  XHBTextAppearance.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public extension TextAppearance {
    
    static let Head = TextAppearance().textWeight(.bold)
    static let Head0 = TextAppearance(copy: .Head).textSize(24)
    static let Head1 = TextAppearance(copy: .Head).textSize(20)
    static let Head2 = TextAppearance(copy: .Head).textSize(18)
    static let Head3 = TextAppearance(copy: .Head).textSize(16)
    static let Head4 = TextAppearance(copy: .Head).textSize(14).textColors(.bluegrey_800_disabled)

    static let Body = TextAppearance()
    static let Body_Large = TextAppearance(copy: .Body).textSize(18)
    static let Body_Middle = TextAppearance(copy: .Body).textSize(16)
    static let Body_Small = TextAppearance(copy: .Body).textSize(14)

    static let Secondary = TextAppearance().textSize(12).textColors(StateListColor(singleColor: .bluegrey_700))
    static let Tip = TextAppearance(copy: .Secondary).textSize(10)

}

