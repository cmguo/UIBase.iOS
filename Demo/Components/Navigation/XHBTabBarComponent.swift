//
//  XHBTabBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/7.
//

import Foundation

class XHBTabBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Navigation

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "选项卡"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBTabBarController()
    }()
}
