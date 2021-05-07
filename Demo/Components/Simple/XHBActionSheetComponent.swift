//
//  XHBActionSheetComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

class XHBActionSheetComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "操作表单"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBActionSheetController()
    }()
}
