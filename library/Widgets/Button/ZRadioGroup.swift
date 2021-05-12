//
//  ZRadioGroup.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation

public class ZRadioGroup : NSObject {
    
    public private(set) var buttonChecked: ZRadioButton? = nil

    private var buttons: [ZRadioButton] = []
    
    public func addRadioButton(_ button: ZRadioButton) {
        if buttons.contains(button) {
            return
        }
        button.addTarget(self, action: #selector(changed(_:)), for: .valueChanged)
        buttons.append(button)
        if button.checked {
            changed(button)
        }
    }
    
    public func removeRadioButton(_ button: ZRadioButton) {
        if let index = buttons.firstIndex(of: button) {
            buttons.remove(at: index)
            if buttonChecked == button {
                buttonChecked = nil
            }
            button.removeTarget(self, action: #selector(changed(_:)), for: .valueChanged)
        }
    }
    
    @objc private func changed(_ sender: ZRadioButton) {
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
