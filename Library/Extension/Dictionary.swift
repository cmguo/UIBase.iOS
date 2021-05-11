//
//  Dictionary.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation

public extension Dictionary {
    
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
