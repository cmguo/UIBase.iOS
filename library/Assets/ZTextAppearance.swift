//
//  ZTextAppearance.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

public extension TextStyle {
    
    static let title = TextAppearance().textWeight(.bold)
    static let title_24 = TextAppearance(copy: .title).textSize(24).lineHeight(36)
    static let title_20 = TextAppearance(copy: .title).textSize(20).lineHeight(32)
    static let title_18 = TextAppearance(copy: .title).textSize(18).lineHeight(28)
    static let title_16 = TextAppearance(copy: .title).textSize(16).lineHeight(24)
    static let title_14 = TextAppearance(copy: .title).textSize(14).lineHeight(20)

    static let body = TextAppearance().textColors(.bluegrey_800_disabled)
    static let body_18 = TextAppearance(copy: .body).textSize(18).lineHeight(28)
    static let body_16 = TextAppearance(copy: .body).textSize(16).lineHeight(24)
    static let body_14 = TextAppearance(copy: .body).textSize(14).lineHeight(20)
    static let body_12 = TextAppearance(copy: .body).textSize(12).lineHeight(20)
    static let body_10 = TextAppearance(copy: .body).textSize(10).lineHeight(20)

}

public extension TextAppearance {
    
    static let head = title
    static let head0 = title_24
    static let head1 = title_20
    static let head2 = title_18
    static let head3 = title_16
    static let head4 = TextAppearance(style: .title_14, textColors: .bluegrey_800_disabled)

    static let body_large = body_18
    static let body_middle = body_16
    static let body_small = body_14

    static let body_secondary = TextAppearance(style: .body_12, textColor: .bluegrey_700)
    static let body_tip = TextAppearance(style: .body_10, textColor: .bluegrey_700)

}

