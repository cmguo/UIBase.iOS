//
//  XHBTextInputComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBTextInputComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Input

    var icon: Int = 0
    
    var title: String = "文本框"
    
    var author: String = "cmguo"
    
    var desc: String = "用于文字输入"
    
    lazy var controller: ComponentController = {
        return XHBTextInputController()
    }()
}
