//
//  UIRepeatTapGestureRecognizer.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/1.
//

import Foundation

public class UIRepeatTapGestureRecognizer : UIGestureRecognizer {
    
    private let target: NSObject
    private let action: Selector
    
    private let initialInterval: Double
    private let repeatInterval: Double
    
    private var working = false
    
    public init(target: NSObject, action: Selector, initialInterval: Double = 0.2, repeatInterval: Double = 0.05) {
        self.target = target
        self.action = action
        self.initialInterval = initialInterval
        self.repeatInterval = repeatInterval
        super.init(target: target, action: action)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        working = true
        target.perform(action, with: self)
        DispatchQueue.main.delay(initialInterval, execute: {
            self.handleAsync()
        })
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
        working = false
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
        working = false
    }
    
    public override func reset() {
        working = false
    }
    
    private func handleAsync() {
        if working {
            // we can't control .change rate, so keep in .possible state
            // state = .begin
            target.perform(action, with: self)
            DispatchQueue.main.delay(repeatInterval, execute: {
                self.handleAsync()
            })
        }
    }
}
