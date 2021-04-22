//
//  XHBPickerViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

class XHBPickerViewComponent : NSObject, Component
{
    var group: String = "选择交互控件"
        
    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "选择器"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBPickerViewController()
    }()
}
