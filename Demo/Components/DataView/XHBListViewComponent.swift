//
//  XHBListViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation

class XHBListViewComponent : NSObject, Component
{
    var group: ComponentGroup = .DataView

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "列表"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBListViewController()
    }()
}
