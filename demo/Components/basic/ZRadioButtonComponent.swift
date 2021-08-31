//
//  ZRatioComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZRadioButtonComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Basic

    var icon: URL? = nil
    
    var title: String = "单选框"
    
    var author: String = "cmguo"
    
    var desc: String = "单选框用来表示选项已被选中且只能选中一个。"
    
    lazy var controller: ComponentController = {
        return ZCompoundButtonController(self)
    }()
}
