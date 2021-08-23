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
    
    static let pressed = highlighted
    static let checked = UIControl.State(rawValue: 0x10000)
    static let half_checked = UIControl.State(rawValue: 0x20000)
    static let error = UIControl.State(rawValue: 0x40000)

    static let pressed_selected = UIControl.State([pressed, selected])
    static let disabled_selected = UIControl.State([disabled, selected])
    static let disabled_checked = UIControl.State([disabled, checked])
    static let disabled_half_checked = UIControl.State([disabled, half_checked])

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
        self.statesColors = [StateColor(singleColor, .normal)]
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
        return color(for: .normal)
    }
    
    public func disabledColor() -> UIColor {
        return color(for: .disabled)
    }
    
    public func pressedColor() -> UIColor {
        return color(for: .pressed)
    }

}
