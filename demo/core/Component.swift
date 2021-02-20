//
//  Component.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit

public protocol Component
{
    var id: Int { get }
    var group: Int { get }
    var icon: Int { get }
    var title: String { get }
    var author: String { get }
    var description: String { get }
    var controller: UIViewController { get }
}
