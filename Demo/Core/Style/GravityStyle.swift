//
//  GravityStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/16.
//

import Foundation
import UIBase

class GravityStyle: ComponentStyle {
    
    init(_ cls: ViewStyles.Type, _ field: String) {
        super.init(cls, field, values: [
            ("LeftTop", String(Gravity.LEFT_TOP)),
            ("CenterTop", String(Gravity.CENTER_TOP)),
            ("RightTop", String(Gravity.RIGHT_TOP)),
            ("LeftCenter", String(Gravity.LEFT_CENTER)),
            ("Center", String(Gravity.CENTER)),
            ("RightCenter", String(Gravity.RIGHT_CENTER)),
            ("LeftBottom", String(Gravity.LEFT_BOTTOM)),
            ("CenterBottom", String(Gravity.CENTER_BOTTOM)),
            ("RightBottom", String(Gravity.RIGHT_BOTTOM)),
        ])
    }

}
