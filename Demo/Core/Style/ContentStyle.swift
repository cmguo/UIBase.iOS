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
    
    static let icon_text: UIView = {
        let v = UILabel()
        v.text = "标签"
        v.textAppearance = TextAppearance(copy: .Secondary).textColor(.blue_600)
        v.clipsToBounds = true
        v.layer.cornerRadius = 9
        v.backgroundColor = .blue_100
        v.textAlignment = .center
        v.bounds.size = CGSize(width: 32, height: 18)
        return v
    }()
    
    static let Contents: [String: Any] = [
        "icon_left": URL.icon_left,
        "icon_more": URL.icon_more,
        "icon_text": icon_text,
        "icon_weixin": Icons.pngURL("img_share_weixin")!,
        "text_cancel": "取消",
        "text_confirm": "确定",
        "image_dialog": Icons.pngURL("dialog1")!,
        "button_goto": ["去查看", URL.icon_right] as [Any?] as NSArray,
        "button_style": [
            "text": "按钮",
            "icon": URL.icon_right,
            "iconPosition": ZButtonAppearance.IconPosition.Right
        ] as NSDictionary,
        "title_icon": [
            "title": "标题",
            "leftButton": URL.icon_close,
            "rightButton": URL.icon_more
        ] as [String: Any?] as NSDictionary,
        "title_text": [
            "icon": icon_text,
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
