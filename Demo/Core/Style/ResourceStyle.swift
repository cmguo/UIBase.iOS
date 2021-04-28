//
//  ResourceStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation
import UIBase

class ResourceStyle: ComponentStyle {
    
    private static let Templates: [String: [String]] = [
        "<button>": ["button", "icon", "text"],
        "<title>": ["title", "text"]
    ]

    private let contents: [String: Any?]
    
    init(_ cls: ViewStyles.Type, _ field: String, _ resources: [String: Any], _ params: [String]) {
        contents = Self.filter(resources, params)
        super.init(cls, field, values: contents.map { i, j in (i, i) })
        values?.insert(("<null>", "<null>"), at: 0)
    }
    
    override func _init(on styles: ViewStyles) {
        var value = super.getRaw(on: styles)
        if let s = value as? String {
            if let v = valueFromString(s) {
                value = v
                setRaw(v, on: styles)
            }
        }
        super._init(on: styles)
    }
    
    override func valueToString(_ value: Any?) -> String {
        if value == nil {
            return "<null>"
        }
        if let cv = value as? AnyClass {
            for (k, v) in contents {
                if let cl = v as? AnyClass, cv == cl {
                    return k
                }
            }
        }
        return ""
    }
    
    override func valueFromString(_ value: String) -> Any? {
        if value == "<null>" {
            return nil
        }
        for (k, v) in contents {
            if k == value {
                return v
            }
        }
        return nil
    }
    
    
    static func filter(_ resources: [String: Any], _ params: [String]) -> [String: Any?] {
        var r: [String: Any?] = [:]
        var types: [String] = []
        var prefs: [String] = []
        for p in params {
            if let tt = Self.Templates[p] {
                for s in tt {
                    if s.starts(with: "@") {
                        types.append(s)
                    } else {
                        prefs.append(s)
                    }
                }
            } else if p.starts(with: "@") {
                types.append(p)
            } else {
                prefs.append(p)
            }
        }
        for (k, v) in resources {
            if !prefs.isEmpty && !prefs.contains(where: { s in k.starts(with: s)}) {
                continue
            }
            r[k] = v
        }
        return r
    }
}
