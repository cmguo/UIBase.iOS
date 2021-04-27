//
//  ZDropDownComponent.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

class ZDropDownComponent : NSObject, Component
{
    var group: ComponentGroup = .MenuList

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "下拉菜单"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ZDropDownController()
    }()
}
