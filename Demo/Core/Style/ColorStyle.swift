//
//  ColorStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation
import UIKit

class ColorStyle : ComponentStyle {
    
    private static let colors = Colors.stdDynamicColors()
    
    init(_ cls: ViewStyles.Type, _ field: String) {
        super.init(cls, field, values: Self.colors.map { key, color -> (String, String) in
            (key, key)
        })
    }
    
    override func valueToString(_ value: Any?) -> String {
        guard let color = value as? UIColor else {
            return ""
        }
        return Self.colors.first(where: { (_, c) in c == color })?.key ?? "<default>"
    }
    
    override func valueFromString(_ value: String) -> Any? {
        return Self.colors[value] ?? nil
    }
    
    
}
