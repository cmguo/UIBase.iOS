//
//  ButtonsComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

class ButtonsComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Resources

    var icon: Int = 0
    
    var title: String = "按钮"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: ComponentController = {
        return ButtonsController()
    }()
}
