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
    
    override func valueToString(_ value: Any?) -> String {
        guard let url = value as? URL else {
            return "<null>"
        }
        return url.pathComponents.last!.replacingOccurrences(of: ".svg", with: "")
    }
    
    override func valueFromString(_ value: String) -> Any? {
        if value == "<null>" {
            return nil
        }
        return Icons.iconURL(value)
    }
    
}
