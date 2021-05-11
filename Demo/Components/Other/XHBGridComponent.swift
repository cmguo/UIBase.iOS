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
        
    var icon: Int = 0
    
    var title: String = "宫格"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ContributionRequestController()
    }()
}
