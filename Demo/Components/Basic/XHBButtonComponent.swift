//
//  XHBButtonComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBButtonComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Basic

    var icon: URL? = nil
    
    var title: String = "按钮"
    
    var author: String = "cmguo"
    
    var desc: String = "按钮包含图标和文字，响应操作状态变化，特别具有加载状态；晓黑板按钮有5种颜色样式，4种尺寸样式。"
    
    lazy var controller: ComponentController = {
        return XHBButtonController()
    }()
}
