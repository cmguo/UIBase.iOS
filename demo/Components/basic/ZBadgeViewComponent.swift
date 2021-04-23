//
//  XHBBadgeComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBBadgeViewComponent : NSObject, Component
{    
    var group: ComponentGroup = .Basic

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "徽章"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return XHBBadgeViewController()
    }()
}
