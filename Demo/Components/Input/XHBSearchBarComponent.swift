//
//  XHBSearchBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation

class XHBSearchBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Input

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "搜索框"
    
    var author: String = "cmguo"
    
    var desc: String = "当应用内包含大量的信息的时候，用户通过搜索快速地定位到特定的内容。"
    
    lazy var controller: ComponentController = {
        return XHBSearchBarController()
    }()
}
