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
        let components = allComponents("^demo\\..+Component")
        var groups : Dictionary<String, Array<Component>> = [:]
        for component in components {
            var group = groups[component.group] ?? []
            group.append(component)
            groups[component.group] = group
        }
        return groups
    }
    
    private class func allComponents(_ pattern: String) -> Array<Component> {
        let pattern = try! NSRegularExpression(pattern: pattern, options: [])
        var components: [Component] = []
        let image = class_getImageName(Components.self)!
        let outCount = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        let classes = objc_copyClassNamesForImage(image, outCount)!
        for i in 0 ..< outCount.pointee {
            let className = String(cString: classes.advanced(by: Int(i)).pointee)
            let matches = pattern.matches(in: className, options: [], range: NSRange(location: 0, length: className.utf8.count))
            if matches.count > 0 {
                print("Found component: " + className)
                if let clazz = NSClassFromString(className),
                   let component = ObjectFactory.create(className) as? Component {
                    components.append(component)
                }
            }
        }
        return components
    }
}
