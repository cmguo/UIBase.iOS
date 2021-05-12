//
//  ZActivityViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation

class ZActivityViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Optional

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "活动视图"
    
    var author: String = "cmguo"
    
    var desc: String = "可以用于承载一次性操作，如分享、复制、收藏、刷新等；面板类型为宫格类；"
    
    lazy var controller: ComponentController = {
        return ZActivityViewController()
    }()
}
