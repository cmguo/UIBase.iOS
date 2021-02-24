//
//  ComponentStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation
import SwiftReflection

public class ComponentStyle
{
    let field: objc_property_t
    let title: String
    let name: String
    let valueType: Any
    let values: Array<String>? = nil
    
    var valyeTypeName: String { get { return "\(valueType)" } }
    
    init(_ field: objc_property_t) {
        self.field = field;
        self.name = String(cString: property_getName(field))
        self.title = self.name
        valueType = getTypeOf(property: field)
    }
}
