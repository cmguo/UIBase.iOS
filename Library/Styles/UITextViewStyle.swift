//
//  UITextViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/2.
//

import Foundation

public class UITextViewStyle : UIViewStyle {
    
    public var textAppearance = TextAppearance()
    
    public override init() {
        super.init()
    }
    
    public init(copy: UITextViewStyle) {
        super.init(copy: copy)
        textAppearance = copy.textAppearance
    }
    
}
