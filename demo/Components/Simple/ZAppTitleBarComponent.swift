//
//  XHBAppTitleBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

class XHBAppTitleBarComponent : NSObject, Component
{
    var group: String = "页面跳转控件"
        
    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "标题栏"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBAppTitleBarController()
    }()
}
