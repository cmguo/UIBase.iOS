//
//  ZTabBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/7.
//

import Foundation

class ZTabBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Navigation

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "选项卡"
    
    var author: String = "cmguo"
    
    var desc: String = "一般作为二级导航，将页面内容按照不同视图进行分类，用户点击可切换到不同视图。"
    
    lazy var controller: ComponentController = {
        return ZTabBarController()
    }()
}
