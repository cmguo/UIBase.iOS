//
//  XHBGridComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation

class XHBGridComponent : NSObject, Component
{
    var group: ComponentGroup = .Other
        
    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "宫格"
    
    var author: String = "cmguo"
    
    var desc: String = "宫格主要作为信息聚合的目的，通过图标集合清晰展现各个入口。在这种界面中，用户的行为主要在寻找信息入口。信息呈现的内容比较少，效率比较高。用户也比较容易记住各入口位置，但是宫格不宜过多，宫格越多，用户的选择压力越多。"
    
    lazy var controller: ComponentController = {
        return ContributionRequestController()
    }()
}
