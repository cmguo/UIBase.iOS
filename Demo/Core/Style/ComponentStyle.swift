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

public class ComponentStyle : NSObject
{
    let name: String
    let title: String
    let desc: String
    let valueType: Any.Type
    var values: Array<(String, String)>?
    var defValue: Any = ""

    var valueTypeName: String { get { return "\(valueType)" } }
    
    init(_ cls: ViewStyles.Type, _ name: String, values: Array<(String, String)>? = nil) {
        let field = class_getProperty(cls, name.cString(using: .utf8)!)!;
        self.name = name
        self.valueType = getTypeOf(property: field) as! Any.Type
        self.values = values
        if let descs = cls.value(forKey: "_\(self.name)") as? NSArray {
            self.title = descs[0] as! String
            self.desc = "\(self.name): \(self.valueType)  \(descs[1] as! String)"
        } else {
            self.title = self.name.capitalizingFirstLetter()
            self.desc = "\(self.name): \(self.valueType)"
        }
    }
    
    init(_ cls: ViewStyles.Type, _ field: objc_property_t) {
        self.name = String(cString: property_getName(field))
        self.valueType = getTypeOf(property: field) as! Any.Type
        let values = cls.value(forKey: "_\(self.name)Values") as? NSArray
        self.values = values?.map({ (value: Any?) -> (String, String) in
            if let e = value as? NSDictionary.Element {
                return (e.key as! String, e.value as! String)
            } else {
                return ("", "")
            }
        })
        if let descs = cls.value(forKey: "_\(self.name)") as? NSArray {
            self.title = descs[0] as! String
            self.desc = "\(self.name): \(self.valueType)  \(descs[1] as! String)"
        } else {
            self.title = self.name.capitalizingFirstLetter()
            self.desc = "\(self.name): \(self.valueType)"
        }
    }
    
    func setValues(_ values: Array<(String, String)>) {
        //self.values = values
    }
    
    func _init(on styles: ViewStyles) {
        guard let values = values else {
            return
        }
        guard let value = getRaw(on: styles) else {
            return
        }
        let name = valueToString(value)
        if !values.contains(where: { k, v in v == name }) {
            var vs = values
            vs.insert(("<default>", "<default>"), at: 0)
            self.values = vs
            self.defValue = value
        }
    }
    
    func set(_ value: String, on styles: ViewStyles) {
        let value = valueFromString(value)
        setRaw(value, on: styles)
    }
    
    func get(on styles: ViewStyles) -> String {
        return valueToString(getRaw(on: styles))
    }
    
    func getRaw(on styles: ViewStyles) -> Any? {
        return styles.value(forKey: name)
    }
    
    func setRaw(_ value: Any?, on styles: ViewStyles) {
        styles.setValue(value, forKey: name)
        styles.notify(name)
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
        } else if value == "<default>" {
            return defValue
        } else {
            return value
        }
    }
    
    func valueToString(_ value: Any?) -> String {
        if let cv = value as? AnyObject, let cl = defValue as? AnyObject {
            if cv === cl {
                return "<default>"
            }
        }
        return "\(value ?? "")"
    }
}
