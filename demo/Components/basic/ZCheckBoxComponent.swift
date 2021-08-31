//
//  ZCheckBoxComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZCheckBoxComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Basic

    var icon: URL? = nil
    
    var title: String = "复选框"
    
    var author: String = "cmguo"
    
    var desc: String = "复选框用来表示选项已被选中且可以选择1个或者多个。"
    
    lazy var controller: ComponentController = {
        return ZCompoundButtonController(self)
    }()
}
