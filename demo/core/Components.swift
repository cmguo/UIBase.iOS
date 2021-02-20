//
//  Components.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation

public class Components : NSObject
{
    public class func allGroups() -> Dictionary<String, Array<Component>> {
        var groups : Dictionary<String, Array<Component>> = [:]
        var baseGroup : Array<Component> = []
        baseGroup.append(ColorsComponent())
        baseGroup.append(ButtonsComponent())
        groups["基础样式"] = baseGroup
        return groups
    }
    
    public  func fffr() {
    }
}
