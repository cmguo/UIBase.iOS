//
//  UITextField.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/2.
//

import Foundation

extension UITextField {
        
    open var textFieldStyle: UITextFieldStyle {
        get { return UITextFieldStyle() }
        set {
            super.viewStyle = newValue
            textAppearance = newValue.textAppearance
        }
    }
    
    var textAppearance: TextAppearance {
        get { return TextAppearance() }
        set {
            font = newValue.font
            textColor = newValue.textColor
        }
    }
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }

}
