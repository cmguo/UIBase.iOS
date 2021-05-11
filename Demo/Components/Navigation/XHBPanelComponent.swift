//
//  XHBPanelComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

class XHBPanelComponent : NSObject, Component
{
    var group: ComponentGroup = .Navigation

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "浮层面板"
    
    var author: String = "cmguo"
    
    var desc: String = "浮层面板作为临时的视图容器，可以在不改变或跳出当前页面的前提下，提供额外的信息展示或操作交互。"
    
    lazy var controller: ComponentController = {
        return XHBPanelController()
    }()
}
