//
//  ColorStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation
import UIKit

class ColorStyle : ComponentStyle {
    
    init(_ cls: ViewStyles.Type, _ field: String) {
        super.init(cls, field, values: Colors.stdColors().map { key, color -> (String, String) in
            (key, "\(color)")
        })
    }
    
}
