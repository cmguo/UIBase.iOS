//
//  StateListColor.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

extension UIControl.State {
    public init(states: [UIControl.State]) {
        var bits: UInt = 0
        for s in states {
            bits |= s.rawValue
        }
        self.init(rawValue: bits)
    }
}

extension UIControl.State {
    
    static let STATE_DISABLED = UIControl.State.disabled
    static let STATE_PRESSED = UIControl.State.highlighted
    static let STATE_FOCUSED = UIControl.State.focused
    static let STATE_CHECKED = UIControl.State(rawValue: 0x10000)
    static let STATE_HALF_CHECKED = UIControl.State(rawValue: 0x20000)
    static let STATE_ERROR = UIControl.State(rawValue: 0x40000)

    static let STATES_NORMAL = UIControl.State.normal
    static let STATES_PRESSED = STATE_PRESSED
    static let STATES_DISABLED = STATE_DISABLED
    static let STATES_CHECKED = STATE_CHECKED
    static let STATES_HALF_CHECKED = STATE_HALF_CHECKED
    static let STATES_FOCUSED = STATE_FOCUSED
    static let STATES_ERROR = STATE_ERROR
    static let STATES_DISABLED_CHECKED = UIControl.State([STATE_DISABLED, STATE_CHECKED])
    static let STATES_DISABLED_HALF_CHECKED = UIControl.State([STATE_DISABLED, STATE_HALF_CHECKED])

}

class StateColor {
        
    let color: UIColor
    let states: UIControl.State
    
    init (_ color: UIColor, _ states: UIControl.State) {
        self.color = color
        self.states = states
    }
    
    func matchStates(_ states: UIControl.State) -> Bool {
        return self.states.intersection(states) == self.states
    }
    
}

class StateListColor {
    
    let statesColors: [StateColor]
    
    init(_ statesColors: [StateColor]) {
        self.statesColors = statesColors
    }
    
    func color(for states: UIControl.State) -> UIColor {
        for sc in self.statesColors {
            if (sc.matchStates(states)) {
                return sc.color
            }
        }
        return UIColor()
    }
    
    func normalColor() -> UIColor {
        return color(for: .STATES_NORMAL)
    }
    
    func disabledColor() -> UIColor {
        return color(for: .STATES_DISABLED)
    }
    
    func pressedColor() -> UIColor {
        return color(for: .STATES_PRESSED)
    }

}
