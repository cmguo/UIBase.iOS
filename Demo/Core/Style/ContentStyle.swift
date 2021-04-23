//
//  ContentStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation
import UIKit
import UIBase

class ContentStyle: ComponentStyle {
    
    static let Contents: [String: Any] = [
        "icon_left": URL.icon_left,
        "icon_more": URL.icon_more,
        "text_cancel": "取消",
        "text_confirm": "确定",
        "button_goto": ["去查看", URL.icon_right] as [Any?] as NSArray,
        "button_style": [
            "text": "按钮",
            "icon": URL.icon_right,
            "iconPosition": XHBButton.IconPosition.Right
        ] as NSDictionary,
        "title_icon": [
            "title": "标题",
            "leftButton": URL.icon_close,
            "rightButton": URL.icon_more
        ] as [String: Any?] as NSDictionary,
        "title_text": [
            "icon": {
                let v = UILabel()
                v.text = "标签"
                v.textColor = .blue_600
                v.layer.cornerRadius = 9
                return v
            }(),
            "title": "标题",
            "leftButton": "取消",
            "rightButton": "确定"
        ] as [String: Any?] as NSDictionary,
        "view_text": {
            let v = UILabel()
            v.text = "文字"
            return v
        }(),
    ]
    
    private static let Templates: [String: [String]] = [
        "<button>": ["button", "icon", "text"],
        "<title>": ["title", "text"]
    ]

    private let contents: [String: Any?]
    
    init(_ cls: ViewStyles.Type, _ field: String, _ params: [String]) {
        contents = Self.filter(params)
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
    
    
    static func filter(_ params: [String]) -> [String: Any?] {
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
        for (k, v) in Self.Contents {
            if !prefs.isEmpty && !prefs.contains(where: { s in k.starts(with: s)}) {
                continue
            }
            r[k] = v
        }
        return r
    }
}
