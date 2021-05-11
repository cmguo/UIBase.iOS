//
//  XHBFilterComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation

class XHBFilterComponent : NSObject, Component
{
    var group: ComponentGroup = .Other
        
    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "筛选"
    
    var author: String = "cmguo"
    
    var desc: String = "提供用户在多个选项中进行筛选。"
    
    lazy var controller: ComponentController = {
        return ContributionRequestController()
    }()
}
