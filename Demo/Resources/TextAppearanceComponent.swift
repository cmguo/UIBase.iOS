//
//  TextAppearanceComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/14.
//

import Foundation

class TextAppearanceComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Styles

    var icon: URL? = nil
    
    var title: String = "文字样式"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return AppearancesController(self)
    }()
}
