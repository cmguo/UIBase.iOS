//
//  ZRatioComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZRatioButtonComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Basic

    var icon: Int = 0
    
    var title: String = "单选框"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ZCompoundButtonController(self)
    }()
}
