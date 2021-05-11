//
//  XHBTimePickerViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation

class XHBTimePickerViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "时间选择器"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBTimePickerViewController(self)
    }()
}
