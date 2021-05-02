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
        
    var icon: Int = 0
    
    var title: String = "步进器"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ZNumberViewController()
    }()
}
