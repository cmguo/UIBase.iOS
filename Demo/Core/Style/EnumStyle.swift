//
//  EnumStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation

class EnumStyle<T>: ComponentStyle where T : CaseIterable, T : RawRepresentable {
    
    init(_ cls: ViewStyles.Type, _ field: String, _ enumType: T.Type) {
        super.init(cls, field, values: enumType.allCases.map { (c: T) -> (String, String) in
            return ("\(c)(\(c.rawValue))", "\(c.rawValue)")
        })
    }
    
}
