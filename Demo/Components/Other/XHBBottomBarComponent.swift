//
//  XHBBottomBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation

class XHBBottomBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Other
        
    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "底部栏"
    
    var author: String = "cmguo"
    
    var desc: String = "位于页面底部，用于一级目录的导航，提示用户当前位置及用户切换统一层级之间的不同模块，一般最多不超过五个标签。"
    
    lazy var controller: ComponentController = {
        return ContributionRequestController()
    }()
}
