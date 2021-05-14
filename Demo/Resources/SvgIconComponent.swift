//
//  SvgIconComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/14.
//

import Foundation

class SvgIconComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Resources

    var icon: URL? = nil
    
    var title: String = "图标（SVG）"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return IconsController(self)
    }()
}
