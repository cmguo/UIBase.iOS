//
//  UILabel.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

public extension UILabel {
    
    var textAppearance: TextAppearance {
        get { return TextAppearance() }
        set {
            font = newValue.font
            textColor = newValue.textColor
        }
    }
    

}
