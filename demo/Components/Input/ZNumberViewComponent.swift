//
//  ZNumberViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/1.
//

import Foundation

class ZNumberViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Input

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "步进器"
    
    var author: String = "cmguo"
    
    var desc: String = "用于增加或减少数量的控件。"
    
    lazy var controller: ComponentController = {
        return ZNumberViewController()
    }()
}
