//
//  ZBadgeComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZBadgeViewComponent : NSObject, Component
{    
    var group: ComponentGroup = .Basic

    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "徽章"
    
    var author: String = "cmguo"
    
    var desc: String = "徽章（小圆点）是出现在按钮、图标旁的数字或状态标记。"
    
    lazy var controller: ComponentController = {
        return ZBadgeViewController()
    }()
}
