//
//  ZDropDownComponent.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

class ZDropDownComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "下拉菜单"
    
    var author: String = "cmguo"
    
    var desc: String = "用于提供快速到达其他功能入口的导航，默认收起，点击出现。"
    
    lazy var controller: ComponentController = {
        return ZDropDownController()
    }()
}
