//
//  XHBPickerViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

class XHBPickerViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "选择器"
    
    var author: String = "cmguo"
    
    var desc: String = "临时浮层，用户触发选择操作时出现。从众多选项中选项中选择一个选项。"
    
    lazy var controller: ComponentController = {
        return XHBPickerViewController()
    }()
}
