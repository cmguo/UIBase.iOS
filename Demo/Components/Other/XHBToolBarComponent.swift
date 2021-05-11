//
//  XHBToolBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation

class XHBToolBarComponent : NSObject, Component
{
    var group: ComponentGroup = .Other
        
    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "工具栏"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ContributionRequestController()
    }()
}
