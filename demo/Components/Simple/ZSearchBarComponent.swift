//
//  ZSearchBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation

class ZSearchBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Input

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "搜索框"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ZSearchBarController()
    }()
}
