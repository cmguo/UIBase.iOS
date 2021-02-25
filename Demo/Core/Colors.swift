//
//  Colors.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIKit
import library
import Skin
import SwiftyJSON

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
    
    class func stdColors() -> Dictionary<String, UIColor> {
        SkinManager.instance.configNormalSkin()
        let json = SkinManager.instance.json;
        return json.dictionary?.filter({ (key: String, value: JSON) -> Bool in
            return value.string?.starts(with: "#") ?? false
        }).mapValues({ (value: JSON) in UIColor(hexString:value.string!) }) ?? [:]
        return [:]
    }
    
    class func nonStdColors() -> Dictionary<String, UIColor> {
        return [:]
    }
    
}
