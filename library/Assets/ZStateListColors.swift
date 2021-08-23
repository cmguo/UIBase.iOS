//
//  Colors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/14.
//

import Foundation

public extension StateListColor {
    
    static let clear = StateListColor(singleColor: .clear)
    
    static let blue_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.blue_200, .pressed),
        StateColor(.blue_100, .normal)
    ])
    
    static let blue_600_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.blue_600, .normal)
    ])
    
    static let bluegrey_00_checked_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.brand_500, .checked),
        StateColor(.brand_500, .half_checked),
        StateColor(.bluegrey_00, .normal)
    ])
    
    static let bluegrey_00_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.bluegrey_00, .normal)
    ])
    
    static let bluegrey_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.bluegrey_300, .pressed),
        StateColor(.bluegrey_100, .normal)
    ])
    
    static let bluegrey_300_checked = StateListColor([
        StateColor(.brand_500, .checked),
        StateColor(.bluegrey_300, .normal)
    ])
    
    static let bluegrey_500_checked_disabled = StateListColor([
        StateColor(.bluegrey_300, .disabled),
        StateColor(.brand_500, .checked),
        StateColor(.brand_500, .half_checked),
        StateColor(.bluegrey_500, .normal)
    ])
    
    static let bluegrey_700_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.bluegrey_700, .normal)
    ])
    static let bluegrey_800_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.bluegrey_800, .normal)
    ])
    
    static let bluegrey_800_selected = StateListColor([
        StateColor(.bluegrey_900, .selected),
        StateColor(.bluegrey_800, .normal)
    ])
    
    static let bluegrey_900_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.bluegrey_900, .normal)
    ])
    
    static let bluegrey_900_disabled2 = StateListColor([
        StateColor(.bluegrey_300, .disabled),
        StateColor(.bluegrey_900, .normal)
    ])
    
    static let bluegrey_900_selected_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.red_600, .selected),
        StateColor(.bluegrey_900, .normal)
    ])
    
    static let brand_500_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.brand_600, .pressed),
        StateColor(.brand_500, .normal)
    ])

    static let red_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.red_200, .pressed),
        StateColor(.red_100, .normal)
    ])
    
    static let red_600_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.red_600, .normal)
    ])
    
    static let static_bluegrey_900_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled),
        StateColor(.static_bluegrey_900, .normal)
    ])
    
    static let transparent_checked_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled_checked),
        StateColor(.bluegrey_00, .checked),
        StateColor(.clear, .normal)
    ])
    
    static let transparent_checked_disabled2 = StateListColor([
        StateColor(.bluegrey_500, .disabled_checked),
        StateColor(.brand_500, .checked),
        StateColor(.clear, .normal)
    ])
        
    static let transparent_halfchecked_disabled = StateListColor([
        StateColor(.bluegrey_500, .disabled_half_checked),
        StateColor(.bluegrey_00, .half_checked),
        StateColor(.clear, .normal)
    ])

    static let transparent_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.bluegrey_200, .pressed),
        StateColor(.clear, .normal)
    ])

}
