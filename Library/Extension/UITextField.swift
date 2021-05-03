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
    
}
