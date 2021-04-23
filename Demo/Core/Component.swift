//
//  Component.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

public enum ComponentGroup: Int {
    case Basic
    case Indicator
    case Input
    case MenuList
    case Navigation
    case DataView
    case Complex
    case Style
    case Test
    
    private static let Titles = [
        "基础交互控件", "工具提示控件", "简单输入控件", "菜单选择控件",
        "导航跳转控件", "数据展示控件", "复杂交互控件", "基础样式", "测试分组"
    ]
    
    public func description() -> String {
        return ComponentGroup.Titles[rawValue]
    }
}

public protocol Component : NSObject
{
    var id: Int { get }
    var group: ComponentGroup { get }
    var icon: Int { get }
    var title: String { get }
    var author: String { get }
    var desc: String { get }
    var controller: ComponentController { get }
}

