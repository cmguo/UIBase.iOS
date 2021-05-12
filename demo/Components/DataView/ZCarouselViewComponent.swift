//
//  ZCarouselViewComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

class ZCarouselViewComponent : NSObject, Component
{
    var group: ComponentGroup = .DataView

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "走马灯"
    
    var author: String = "cmguo"
    
    var desc: String = "通过自动切换和手动横滑切换展示相关内容。目前主要用于Banner切换。"
    
    lazy var controller: ComponentController = {
        return ZCarouselViewController()
    }()
}
