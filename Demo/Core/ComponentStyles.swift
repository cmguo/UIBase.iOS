//
//  ComponentStyles.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import ObjectiveC.runtime

class Person : NSObject {
    var name = "Bruce Wayne"
}

class Superhero : Person {
    var hasSuperpowers = true
}

public class ComponentStyles : NSObject
{
    private static var classStyles = Dictionary<String, ComponentStyles>()
    
    //private let parent : ComponentStyles
    let styles: Array<ComponentStyle>
    
    public class func get(styles: ViewStyles) -> ComponentStyles {
        get(cls: type(of: styles))
    }
    
    public class func get(cls: ViewStyles.Type) -> ComponentStyles {
        //if (let sup = cls.superclass())
        let clsName = String(cString: class_getName(cls))
        if let cs = classStyles[clsName] {
            return cs
        }
        let cs = ComponentStyles(cls)
        classStyles[clsName] = cs
        return cs
    }
    
    init(_ cls: ViewStyles.Type) {
        let name = String(cString: class_getName(cls))
        var outCount = UInt32()
        let props = class_copyPropertyList(cls, &outCount)
        var styles = Array<ComponentStyle>()
        print("ComponentStyles \(name) \(outCount)")
        for i in 0 ..< Int(outCount) {
            let cs = ComponentStyle(cls, props![i])
            print("ComponentStyles \(cs.title) \(cs.valyeTypeName)")
            styles.append(cs)
        }
        self.styles = styles
    }
    
    func allStyles() -> Array<ComponentStyle> {
        return styles
    }
}
