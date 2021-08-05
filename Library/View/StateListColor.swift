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

public extension UIControl.State {
    
    static let STATE_DISABLED = disabled
    static let STATE_PRESSED = highlighted
    static let STATE_SELECTED = selected
    static let STATE_FOCUSED = focused
    static let STATE_CHECKED = UIControl.State(rawValue: 0x10000)
    static let STATE_HALF_CHECKED = UIControl.State(rawValue: 0x20000)
    static let STATE_ERROR = UIControl.State(rawValue: 0x40000)

    static let STATES_NORMAL = UIControl.State.normal
    static let STATES_PRESSED = STATE_PRESSED
    static let STATES_DISABLED = STATE_DISABLED
    static let STATES_SELECTED = STATE_SELECTED
    static let STATES_CHECKED = STATE_CHECKED
    static let STATES_HALF_CHECKED = STATE_HALF_CHECKED
    static let STATES_FOCUSED = STATE_FOCUSED
    static let STATES_ERROR = STATE_ERROR
    static let STATES_PRESSED_SELETED = UIControl.State([STATE_PRESSED, STATE_SELECTED])
    static let STATES_DISABLED_SELETED = UIControl.State([STATE_DISABLED, STATE_SELECTED])
    static let STATES_DISABLED_CHECKED = UIControl.State([STATE_DISABLED, STATE_CHECKED])
    static let STATES_DISABLED_HALF_CHECKED = UIControl.State([STATE_DISABLED, STATE_HALF_CHECKED])

}

public class StateColor {
        
    public let color: UIColor
    public let states: UIControl.State
    
    public init (_ color: UIColor, _ states: UIControl.State) {
        self.color = color
        self.states = states
    }
    
    func matchStates(_ states: UIControl.State) -> Bool {
        return self.states.intersection(states) == self.states
    }
    
}

public class StateListColor {
    
    public let statesColors: [StateColor]
    
    public init(singleColor: UIColor) {
        self.statesColors = [StateColor(singleColor, .STATES_NORMAL)]
    }
    
    public init(_ statesColors: [StateColor]) {
        self.statesColors = statesColors
    }
    
    public func color(for states: UIControl.State) -> UIColor {
        for sc in self.statesColors {
            if (sc.matchStates(states)) {
                return sc.color
            }
        }
        return UIColor()
    }
    
    public func normalColor() -> UIColor {
        return color(for: .STATES_NORMAL)
    }
    
    public func disabledColor() -> UIColor {
        return color(for: .STATES_DISABLED)
    }
    
    public func pressedColor() -> UIColor {
        return color(for: .STATES_PRESSED)
    }

}
