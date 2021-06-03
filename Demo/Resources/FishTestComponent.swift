//
//  ButtonsComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

class FishTestComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Test

    var icon: URL? = nil
    
    var title: String = "Fish测试界面"
    
    var author: String = "Fish"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return FishTestController()
    }()

}
