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
    
    var desc: String = "列表将数据呈现为可以分为平铺和分组形式。使用列表以清单的形式干净，高效地显示大量或少量信息。一般来说，列表是基于文本内容的理想选择，也可以在列表中加入图标、按钮、箭头等其他元素扩展场景。"
    
    lazy var controller: ComponentController = {
        return XHBListViewController()
    }()
}
