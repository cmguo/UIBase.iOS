//
//  ComponentStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation

public class ComponentStyle
{
    let field: objc_property_t
    let title: String
    let name: String
    let valueType: AnyClass
    let values: Array<String>? = nil
    
    init(_ field: objc_property_t) {
        self.field = field;
        self.name = String(cString: property_getName(field))
        self.title = self.name
        //let type = String(cString: property_copyAttributeValue(field, "V".cString(using: String.Encoding.utf8)!)!)
        valueType = ComponentStyle.self
        
    }
}
