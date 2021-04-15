//
//  Colors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/14.
//

import Foundation

struct Colors {
    
    static let bluegrey_900_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.bluegrey_900, StateColor.STATES_NORMAL)
    ])
    
    static let blue_600_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.blue_600, StateColor.STATES_NORMAL)
    ])
    
    static let red_600_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.red_600, StateColor.STATES_NORMAL)
    ])
    
    static let bluegrey_800_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.bluegrey_800, StateColor.STATES_NORMAL)
    ])
    
    static let bluegrey_100_pressed_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.bluegrey_300, StateColor.STATES_PRESSED),
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_NORMAL)
    ])
    
    static let red_100_pressed_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.red_500, StateColor.STATES_PRESSED),
        StateColor(ThemeColor.shared.red_100, StateColor.STATES_NORMAL)
    ])
    
    static let transparent_pressed_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.bluegrey_200, StateColor.STATES_PRESSED),
        StateColor(ThemeColor.shared.transparent, StateColor.STATES_NORMAL)
    ])

    static let brand_500_pressed_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.brand_600, StateColor.STATES_PRESSED),
        StateColor(ThemeColor.shared.brand_500, StateColor.STATES_NORMAL)
    ])

    static let blue_100_pressed_disabled = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.blue_200, StateColor.STATES_PRESSED),
        StateColor(ThemeColor.shared.blue_100, StateColor.STATES_NORMAL)
    ])
}
