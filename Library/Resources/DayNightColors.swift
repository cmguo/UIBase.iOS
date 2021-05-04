//
//  UIColors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation

public class DayNightColors {
    
    fileprivate static var wrappers = [DayNightColorWrapper]()
    
    public static func setDayNight(night: Bool) {
        for w in wrappers {
            w.color = UIColor(rgba: night ? w.dayColor : w.nightColor)
        }
    }
    
    public static func colors() -> [String:UIColor] {
        return Dictionary(uniqueKeysWithValues: wrappers.map({ w in (w.name, w.wrappedValue) }))
    }

}

@propertyWrapper
class DayNightColorWrapper {
    
    let name: String
    let dayColor: UInt
    let nightColor: UInt
    var color: UIColor
    
    public var wrappedValue: UIColor {
        get { return color }
    }
    
    init(name: String, dayColor: UInt, nightColor: UInt) {
        self.name = name
        self.dayColor = dayColor
        self.nightColor = nightColor
        self.color = UIColor(rgba: dayColor)
        DayNightColors.wrappers.append(self)
    }
}
