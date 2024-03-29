//
//  ZSwitchComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZSwitchButtonComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Basic

    var icon: URL? = nil
    
    var title: String = "开关"
    
    var author: String = "cmguo"
    
    var desc: String = "开关表示两种相互对立的状态间的切换，例如开/关、是/否状态。"
    
    lazy var controller: ComponentController = {
        return ZCompoundButtonController(self)
    }()
}
