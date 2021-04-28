//
//  ZActivityViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation

class ZActivityViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "活动视图"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ZActivityViewController()
    }()
}
