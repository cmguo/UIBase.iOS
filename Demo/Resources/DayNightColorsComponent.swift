//
//  DynamicColorsComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation

class DayNightColorsComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Resources

    var icon: URL? = nil
    
    var title: String = "颜色（动态）"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ColorsController(self)
    }()
}
