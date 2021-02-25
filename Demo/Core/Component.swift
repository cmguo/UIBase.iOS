//
//  Component.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

public protocol Component : NSObject
{
    var id: Int { get }
    var group: String { get }
    var icon: Int { get }
    var title: String { get }
    var author: String { get }
    var desc: String { get }
    var controller: ComponentController { get }
}

