//
//  XHBDatePickerViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/29.
//

import Foundation

class XHBDatePickerViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "日期选择器"
    
    var author: String = "cmguo"
    
    var desc: String = "一般由选择框触发，弹层的形式建立可滚动视图，并在视图中分段选取时间值。（UIKit 实现）"
    
    lazy var controller: ComponentController = {
        return XHBTimePickerViewController(self)
    }()
}
