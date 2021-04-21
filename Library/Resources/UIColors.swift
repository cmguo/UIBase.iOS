//
//  UIColors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation

@propertyWrapper
class DayNightColorWrapper {
    
    let dayColor: UInt
    let nightColor: UInt
    var color: UIColor
    
    var wrappedValue: UIColor {
        get { return color }
    }
    
    init(dayColor: UInt, nightColor: UInt) {
        self.dayColor = dayColor
        self.nightColor = nightColor
        self.color = UIColor(rgba: dayColor)
        Self.wrappers.append(self)
    }
    
    private static var wrappers = [DayNightColorWrapper]()
    
    public static func setDayNight(night: Bool) {
        for w in wrappers {
            w.color = UIColor(rgba: night ? w.dayColor : w.nightColor)
        }
    }
}
