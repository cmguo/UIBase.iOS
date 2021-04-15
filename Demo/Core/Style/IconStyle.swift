//
//  IconStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation

class IconStyle : ComponentStyle {
    
    init(_ cls: ViewStyles.Type, _ field: String) {
        super.init(cls, field, values: Icons.icons.map { i in (i, i) })
    }
    
}
