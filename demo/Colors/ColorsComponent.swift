//
//  ColorsComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

class ColorsComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: String = "基础样式"

    var icon: Int = 0
    
    var title: String = "标准色"
    
    var author: String = "cmguo"
    
    var desc: String = ""
    
    lazy var controller: UIViewController = {
        return ColorsController()
    }()
}
