//
//  Colors.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIBase

class Colors {
    
    class func stdDynamicColors() -> Dictionary<String, UIColor> {
        let _ = UIColor.dynamicColors
        return DayNightColors.colors()
    }
    
    class func stdStaticColors() -> Dictionary<String, UIColor> {
        return UIColor.staticColors
    }
    
    class func stateListColors() -> Dictionary<String, StateListColor> {
        return [
            "blue_100_pressed_disabled": .blue_100_pressed_disabled,
            "blue_600_disabled": .blue_600_disabled,
            "bluegrey_00_checked_disabled": .bluegrey_00_checked_disabled,
            "bluegrey_00_disabled": .bluegrey_00_disabled,
            "bluegrey_100_pressed_disabled": .bluegrey_100_pressed_disabled,
            "bluegrey_300_checked": .bluegrey_300_checked,
            "bluegrey_500_checked_disabled": .bluegrey_500_checked_disabled,
            "bluegrey_700_disabled": .bluegrey_700_disabled,
            "bluegrey_800_disabled": .bluegrey_800_disabled,
            "bluegrey_800_selected": .bluegrey_800_selected,
            "bluegrey_900_disabled": .bluegrey_900_disabled,
            "bluegrey_900_disabled2": .bluegrey_900_disabled2,
            "bluegrey_900_selected_disabled": .bluegrey_900_selected_disabled,
            "brand_500_pressed_disabled": .brand_500_pressed_disabled,
            "red_100_pressed_disabled": .red_100_pressed_disabled,
            "red_600_disabled": .red_600_disabled,
            "transparent_checked_disabled": .transparent_checked_disabled,
            "transparent_checked_disabled2": .transparent_checked_disabled2,
            "transparent_halfchecked_disabled": .transparent_halfchecked_disabled,
            "transparent_pressed_disabled": .transparent_pressed_disabled,
        ]
    }
    
    static func colorName(_ color: UIColor) -> String {
        return stdDynamicColors().first(where: { k, v in v === color })?.key
            ?? stdStaticColors().first(where: { k, v in v === color })?.key
            ??  color.hexString()
    }

    
    static func colorName(_ color: StateListColor) -> String {
        return stateListColors().first(where: { k, v in v === color })?.key
            ?? colorName(color.normalColor())
    }
}
