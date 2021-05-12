//
//  ZTimePickerViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation

class ZTimePickerViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "时间选择器"
    
    var author: String = "cmguo"
    
    var desc: String = "一般由选择框触发，弹层的形式建立可滚动视图，并在视图中分段选取时间值。"
    
    lazy var controller: ComponentController = {
        return ZTimePickerViewController(self)
    }()
}
