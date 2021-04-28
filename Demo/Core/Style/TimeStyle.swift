//
//  TimeStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation

class TimeStyle : ComponentStyle {
    
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()
    
//    init(_ cls: ViewStyles.Type, _ field: String) {
//        super.init(cls, field})
//    }
    
    
    override func valueToString(_ value: Any?) -> String {
        guard let date = value as? Date else {
            return ""
        }
        return Self.formatter.string(from: date)
    }
    
    override func valueFromString(_ value: String) -> Any? {
        Self.formatter.date(from: value)
    }
}
