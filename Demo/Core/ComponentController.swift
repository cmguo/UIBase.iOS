//
//  ComponentController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation
import UIKit

public protocol IComponentController {
    
    func getStyles() -> ViewStyles
    
}

public class ComponentController : UIViewController, IComponentController {
    
    public func getStyles() -> ViewStyles {
        fatalError("getStyles() has not been implemented")
    }
    
}
