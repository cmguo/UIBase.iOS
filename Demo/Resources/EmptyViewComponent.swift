//
//  ButtonsComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

class EmptyViewComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .DataView

    var icon: URL? = nil
    
    var title: String = "EmptyView"
    
    var author: String = "Fish"
    
    var desc: String = "晓黑板共用空态界面"
    
    lazy var controller: ComponentController = {
        return EmptyViewController()
    }()

}
