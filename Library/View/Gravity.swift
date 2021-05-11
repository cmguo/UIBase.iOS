//
//  Gravity.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/16.
//

import Foundation

public struct Gravity {
    
    public static let LEFT = 1
    public static let TOP = 2
    public static let RIGHT = 4
    public static let BOTTOM = 8
    
    public static let CENTER_VERTICAL = 16
    public static let CENTER_HORIZONTAL = 32
    
    public static let LEFT_TOP = LEFT | TOP
    public static let CENTER_TOP = CENTER_HORIZONTAL | TOP
    public static let RIGHT_TOP = RIGHT | TOP
    public static let LEFT_CENTER = LEFT | CENTER_VERTICAL
    public static let CENTER = CENTER_HORIZONTAL | CENTER_VERTICAL
    public static let RIGHT_CENTER = RIGHT | CENTER_VERTICAL
    public static let LEFT_BOTTOM = LEFT | BOTTOM
    public static let CENTER_BOTTOM = CENTER_HORIZONTAL | BOTTOM
    public static let RIGHT_BOTTOM = RIGHT | BOTTOM
}
