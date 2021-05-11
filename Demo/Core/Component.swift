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
    case DataView
    case Indicator
    case Input
    case Navigation
    case Optional
    case Other
    case Resources
    case Test
    
    private static let Titles = [
        "基础交互控件", "数据展示控件", "工具提示控件", "数值输入控件",
        "导航跳转控件", "菜单选择控件", "其他控件", "资源样式", "测试分组"
    ]
    
    public func description() -> String {
        return ComponentGroup.Titles[rawValue]
    }
}

public protocol Component : NSObject
{
    var id: Int { get }
    var group: ComponentGroup { get }
    var icon: URL? { get }
    var title: String { get }
    var author: String { get }
    var desc: String { get }
    var controller: ComponentController { get }
}
