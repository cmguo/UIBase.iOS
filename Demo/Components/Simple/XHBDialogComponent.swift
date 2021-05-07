//
//  XHBDialogComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/27.
//

import Foundation

class XHBDialogComponent : NSObject, Component
{
    var group: ComponentGroup = .Indicator

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "对话框"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBDialogController()
    }()
}
