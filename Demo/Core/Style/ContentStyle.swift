//
//  ContentStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation
import UIKit
import UIBase

class ContentStyle: ResourceStyle {
    
    static let Contents: [String: Any] = [
        "icon_left": URL.icon_left,
        "icon_more": URL.icon_more,
        "text_cancel": "取消",
        "text_confirm": "确定",
        "image_dialog": Icons.pngURL("dialog1")!,
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
    
    init(_ cls: ViewStyles.Type, _ field: String, _ params: [String]) {
        super.init(cls, field, Self.Contents, params)
    }
    
}
