//
//  ComponentStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation
import SwiftReflection

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public class ComponentStyle
{
    let field: objc_property_t
    let name: String
    let title: String
    let desc: String
    let valueType: Any.Type
    let values: Array<(String, String)>?

    var valyeTypeName: String { get { return "\(valueType)" } }
    
    init(_ cls: ViewStyles.Type, _ field: objc_property_t) {
        self.field = field;
        self.name = String(cString: property_getName(field))
        self.valueType = getTypeOf(property: field) as! Any.Type
        let values = ObjectFactory.values(forStyle: cls, style: self.name)
        self.values = values?.map({ (value: Any?) -> (String, String) in
            if let e = value as? NSDictionary.Element {
                return (e.key as! String, e.value as! String)
            } else {
                return ("", "")
            }
        })
        if let descs = ObjectFactory.descs(forStyle: cls, style: self.name) {
            self.title = descs[0] as! String
            self.desc = descs[1] as! String
        } else {
            self.title = self.name.capitalizingFirstLetter()
            self.desc = self.name
        }
    }
    
    func set(_ value: String, on styles: ViewStyles) {
        if let value = valueFromString(value) {
            styles.setValue(value, forKey: name)
            styles.notify(name)
        }
    }
    
    func get(on styles: ViewStyles) -> String {
        return valueToString(styles.value(forKey: name))
    }
    
    func valueFromString(_ value: String) -> Any? {
        if valueType == Bool.self {
            return Bool.init(value)
        } else if valueType == Int.self {
            return Int.init(value)
        } else if valueType == Double.self {
            return Double.init(value)
        } else if valueType == NSString.self {
            return value
        } else {
            return value
        }
    }
    
    func valueToString(_ value: Any?) -> String {
        return "\(value ?? "")"
    }
}
