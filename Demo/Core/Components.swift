//
//  Components.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation

public class Components : NSObject
{
    static var groups: Dictionary<ComponentGroup, Array<ComponentInfo>>? = nil
    
    public class func allGroups() -> Dictionary<ComponentGroup, Array<ComponentInfo>> {
        if let g = groups {
            return g
        }
        let components = allComponents("^Demo\\..+Component")
        var groups : Dictionary<ComponentGroup, Array<ComponentInfo>> = [:]
        for component in components {
            var group = groups[component.component.group] ?? []
            group.append(component)
            groups[component.component.group] = group
        }
        Components.groups = groups
        return groups
    }
    
    private class func allComponents(_ pattern: String) -> Array<ComponentInfo> {
        let pattern = try! NSRegularExpression(pattern: pattern, options: [])
        var components: [ComponentInfo] = []
        let image = class_getImageName(Components.self)!
        var outCount = UInt32()
        let classes = objc_copyClassNamesForImage(image, &outCount)!
        for i in 0 ..< Int(outCount) {
            let className = String(cString: classes[i])
            let matches = pattern.matches(in: className, options: [], range: NSRange(location: 0, length: className.utf8.count))
            if matches.count > 0 {
                print("Found component: " + className)
                if let component = ObjectFactory.create(className) as? Component {
                    components.append(ComponentInfo(component))
                }
            }
        }
        return components
    }
}
