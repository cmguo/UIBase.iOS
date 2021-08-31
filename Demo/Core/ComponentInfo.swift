//
//  ComponentInfo.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation

public class ComponentInfo {
    
    public let component: Component
    
    public let icon: URL
    
    public var stars: Int = 0
    
    private static var icons: [URL] = Array(URLs.svgIcons.values)

    init(_ component: Component) {
        self.component = component
        icon = component.icon ?? Self.icons.remove(at: 0)
    }
}
