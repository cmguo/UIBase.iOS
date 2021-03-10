//
//  XHBBadgeComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBBadgeComponent : NSObject, Component
{    
    var group: String = ""
        
    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "徽章"
    
    var author: String = "mazhengyu"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBBadgeController()
    }()
}
