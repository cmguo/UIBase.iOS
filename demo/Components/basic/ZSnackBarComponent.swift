//
//  XHBNoticeBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/3/19.
//

import Foundation
import UIKit

class XHBSnackBarComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: String = "基础交互控件"

    var icon: Int = 0
    
    var title: String = "横幅提示"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBTipViewController(self)
    }()
}
