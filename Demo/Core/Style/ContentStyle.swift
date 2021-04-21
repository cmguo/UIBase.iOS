//
//  ContentStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

class ContentStyle: ComponentStyle {
    
    init(_ cls: ViewStyles.Type, _ field: String, _ params: [String]) {
        super.init(cls, field, values: Icons.icons.map { i in (i, i) })
    }
}
