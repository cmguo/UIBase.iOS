//
//  ZAppTitleBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

class ZAppTitleBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Navigation

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "标题栏"
    
    var author: String = "cmguo"
    
    var desc: String = "导航栏出现在屏幕顶部的状态栏下方，并可以通过⼀系列分层屏幕进行导航。当显示新屏幕时，通常标有前⼀屏幕的后退按钮出现在栏的左侧。有时，导航栏的右侧包含⼀个控件，如编辑或完成按钮，⽤于管理活动视图中的内容。"
    
    lazy var controller: ComponentController = {
        return ZAppTitleBarController()
    }()
}
