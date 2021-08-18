//
//  UIColors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation

public class DayNightColors {
    
    private static var wrappers = [DayNightColorWrapper]()
    
    private static var isNight: Bool? = nil
    
    public static func setDayNight(night: Bool) {
        isNight = night
        for w in wrappers {
            w.color = UIColor(rgba: night ? w.nightColor : w.dayColor)
        }
    }
    
    public static func colors() -> [String: UIColor] {
        return Dictionary(uniqueKeysWithValues: wrappers.map({ w in (w.name, w.color) }))
    }
    
    public static func color(for name: String) -> UIColor? {
        return wrappers.first { w in w.name == name }?.color
    }
    
    public static func color(cgColor color: CGColor) -> UIColor? {
        let rgba = UIColor(cgColor: color).rgba()
        return wrappers.first { w in w.dayColor == rgba }?.color
    }
    
    fileprivate static func appendWrapper(_ w : DayNightColorWrapper) {
        if let night = isNight {
            w.color = UIColor(rgba: night ? w.nightColor : w.dayColor)
        }
        wrappers.append(w)
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
        if #available(iOS 13.0, *) {
            let dayColor = UIColor(rgba: dayColor)
            let nightColor = UIColor(rgba: nightColor)
            self.color = UIColor(
                dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light
                        ? dayColor : nightColor})
        } else {
            self.color = UIColor(rgba: dayColor)
        }
        DayNightColors.appendWrapper(self)
    }
}
