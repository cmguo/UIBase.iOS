//
//  Colors.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIBase

extension Dictionary {
    func mapValues<T>(transform: (Value)->T) -> Dictionary<Key,T> {
        var dict = Dictionary<Key,T>();
        let array = self.map { (k: Key, v: Value) in
            return (k, transform(v))
        }
        for (k, v) in array {
            dict[k] = v;
        }
        return dict;
    }
}

class Colors {
    
    class func stdDynamicColors() -> Dictionary<String, UIColor> {
        return DayNightColors.colors()
    }
    
    class func nonStdColors() -> Dictionary<String, UIColor> {
        return [:]
    }
    
}
