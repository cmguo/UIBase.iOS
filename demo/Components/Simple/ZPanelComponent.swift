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
        
    var icon: Int = 0
    
    var title: String = "浮层面板"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBPanelController()
    }()
}
