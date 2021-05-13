//
//  URL.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation


public class SvgIconURLs {
    
    fileprivate static var wrappers = [SvgIconURLWrapper]()
    
    public static func icons() -> [String: URL] {
        return Dictionary(uniqueKeysWithValues: wrappers.map({ w in (w.icon, w.url) }))
    }

}

@propertyWrapper
class SvgIconURLWrapper {
    
    static let rootURL: URL = {
        if let bundle = Bundle(url: Bundle(for: SvgIconURLs.self).bundleURL.appendingPathComponent("Frameworks/UIBase.framework")) {
            return bundle.url(forResource: "UIBase", withExtension: "bundle")!
        } else {
            return Bundle.main.url(forResource: "Frameworks/UIBase", withExtension: "bundle")!
        }
    }()
    
    let icon: String
    lazy var url: URL = {
        //return Self.bundle.url(forResource: icon, withExtension: "svg")!
        return Self.rootURL.appendingPathComponent("Icons/\(icon).svg")
    }()
    
    var wrappedValue: URL {
        get { return url }
    }
    
    init(_ icon: String) {
        self.icon = icon
        SvgIconURLs.wrappers.append(self)
    }
    
}
