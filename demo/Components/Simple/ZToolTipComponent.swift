//
//  XHBToolTipComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBToolTipComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: String = "简单交互控件"

    var icon: Int = 0
    
    var title: String = "气泡提示"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBTipViewController(self)
    }()
}
