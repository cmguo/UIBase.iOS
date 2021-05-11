//
//  XHBToastComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBToastComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Indicator

    var icon: URL? = nil
    
    var title: String = "简单提示"
    
    var author: String = "cmguo"
    
    var desc: String = "包含一行与进行的操作直接相关的文案，它可以包含一个操作。"
    
    lazy var controller: ComponentController = {
        return XHBTipViewController(self)
    }()
}
