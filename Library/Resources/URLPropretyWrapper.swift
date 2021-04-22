//
//  URL.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

@propertyWrapper
class SvgIconURLWrapper {
    
    static let bundle = Bundle.init(for: SvgIconURLWrapper.self)
    
    let icon: String
    lazy var url: URL = { return Self.bundle.url(forResource: icon, withExtension: "svg")! }()
    
    var wrappedValue: URL {
        get { return url }
    }
    
    init(_ icon: String) {
        self.icon = icon
    }
    
}
