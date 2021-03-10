//
//  StateListColor.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

class StateColor {
    
    static let STATE_DISABLED = 1
    static let STATE_PRESSED = 2
    static let STATE_CHECKED = 4
    static let STATE_HALF_CHECKED = 8
    static let STATE_FOCUSED = 16
    static let STATE_ERROR = 32

    static let STATES_NORMAL = 0
    static let STATES_PRESSED = STATE_PRESSED
    static let STATES_DISABLED = STATE_DISABLED
    static let STATES_CHECKED = STATE_CHECKED
    static let STATES_HALF_CHECKED = STATE_HALF_CHECKED
    static let STATES_FOCUSED = STATE_FOCUSED
    static let STATES_ERROR = STATE_ERROR
    static let STATES_DISABLED_CHECKED = STATE_DISABLED | STATE_CHECKED
    static let STATES_DISABLED_HALF_CHECKED = STATE_DISABLED | STATE_HALF_CHECKED

    let color: UIColor
    let states: Int
    
    init (_ color: UIColor, _ states: Int) {
        self.color = color
        self.states = states
    }
    
    func matchStates(_ states: Int) -> Bool {
        return (self.states & states) == self.states
    }
    
}

class StateListColor {
    
    let statesColors: [StateColor]
    
    init(_ statesColors: [StateColor]) {
        self.statesColors = statesColors
    }
    
    func color(for states: Int) -> UIColor {
        for sc in self.statesColors {
            if (sc.matchStates(states)) {
                return sc.color
            }
        }
        return UIColor()
    }
    
    func normalColor() -> UIColor {
        return color(for: StateColor.STATES_NORMAL)
    }
    
    func disabledColor() -> UIColor {
        return color(for: StateColor.STATES_DISABLED)
    }
    
    func pressedColor() -> UIColor {
        return color(for: StateColor.STATES_PRESSED)
    }

}
