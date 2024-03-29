//
//  ZToolTipComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZToolTipComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Indicator

    var icon: URL? = nil
    
    var title: String = "气泡提示"
    
    var author: String = "cmguo"
    
    var desc: String = "当需要提示一些简单的信息的时候，可以使用Tooltip。"
    
    lazy var controller: ComponentController = {
        return ZTipViewController(self)
    }()
}
