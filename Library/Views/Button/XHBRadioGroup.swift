//
//  XHBRadioGroup.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation

public class XHBRadioGroup : NSObject {
    
    public private(set) var buttonChecked: XHBRadioButton? = nil

    private var buttons: [XHBRadioButton] = []
    
    public func addRadioButton(_ button: XHBRadioButton) {
        if buttons.contains(button) {
            return
        }
        button.addTarget(self, action: #selector(changed(_:)), for: .valueChanged)
        buttons.append(button)
        if button.checked {
            changed(button)
        }
    }
    
    public func removeRadioButton(_ button: XHBRadioButton) {
        if let index = buttons.firstIndex(of: button) {
            buttons.remove(at: index)
            if buttonChecked == button {
                buttonChecked = nil
            }
            button.removeTarget(self, action: #selector(changed(_:)), for: .valueChanged)
        }
    }
    
    @objc private func changed(_ sender: XHBRadioButton) {
        if sender.checked {
            buttonChecked = sender
            for button in buttons {
                if button != sender {
                    button.checked = false
                }
            }
        }
    }
    
}
