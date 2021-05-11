//
//  Colors.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIBase

class Colors {
    
    class func stdDynamicColors() -> Dictionary<String, UIColor> {
        return DayNightColors.colors()
    }
    
    class func nonStdColors() -> Dictionary<String, UIColor> {
        return [:]
    }
    
}
