//
//  XHBTextAreaComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBTextAreaComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Input

    var icon: Int = 0
    
    var title: String = "文本域"
    
    var author: String = "cmguo"
    
    var desc: String = "用于长文本输入，提供换行功能，支持多段落格式，通常搭配输入长度限制。"
    
    lazy var controller: ComponentController = {
        return XHBTextAreaController()
    }()
}
