//
//  ZDatePickerViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/29.
//

import Foundation

class ZDatePickerViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "日期选择器"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ZTimePickerViewController(self)
    }()
}
