//
//  ZActionSheetComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

class ZActionSheetComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "操作表单"
    
    var author: String = "cmguo"
    
    var desc: String = "操作表单是响应于控件或动作出现的特定风格的面板，并呈现与当前上下文相关的一组两个或多个选项。使用操作菜单让人们启动任务，或者在执行潜在的破坏性操作之前请求确认。"
    
    lazy var controller: ComponentController = {
        return ZActionSheetController()
    }()
}
