//
//  Colors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/14.
//

import Foundation

extension StateListColor {
    
    static let bluegrey_900_disabled = StateListColor([
        StateColor(.bluegrey_500, .STATES_DISABLED),
        StateColor(.bluegrey_900, .STATES_NORMAL)
    ])
    
    static let blue_600_disabled = StateListColor([
        StateColor(.bluegrey_500, .STATES_DISABLED),
        StateColor(.blue_600, .STATES_NORMAL)
    ])
    
    static let red_600_disabled = StateListColor([
        StateColor(.bluegrey_500, .STATES_DISABLED),
        StateColor(.red_600, .STATES_NORMAL)
    ])
    
    static let bluegrey_800_disabled = StateListColor([
        StateColor(.bluegrey_500, .STATES_DISABLED),
        StateColor(.bluegrey_800, .STATES_NORMAL)
    ])
    
    static let bluegrey_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.bluegrey_300, .STATES_PRESSED),
        StateColor(.bluegrey_100, .STATES_NORMAL)
    ])
    
    static let red_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.red_500, .STATES_PRESSED),
        StateColor(.red_100, .STATES_NORMAL)
    ])
    
    static let transparent_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.bluegrey_200, .STATES_PRESSED),
        StateColor(.clear, .STATES_NORMAL)
    ])

    static let brand_500_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.brand_600, .STATES_PRESSED),
        StateColor(.brand_500, .STATES_NORMAL)
    ])

    static let blue_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.blue_200, .STATES_PRESSED),
        StateColor(.blue_100, .STATES_NORMAL)
    ])
}
