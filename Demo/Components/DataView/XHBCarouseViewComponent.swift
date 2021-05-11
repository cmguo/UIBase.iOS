//
//  XHBCarouseViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

class XHBCarouseViewComponent : NSObject, Component
{
    var group: ComponentGroup = .DataView

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "走马灯"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBCarouseViewController()
    }()
}
