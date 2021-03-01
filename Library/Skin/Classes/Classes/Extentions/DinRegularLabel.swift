//
//  DinRegularLabel.swift
//  blackboard
//
//  Created by 宋昌鹏 on 2018/4/2.
//  Copyright © 2018年 xkb. All rights reserved.
//

import UIKit

public class DinRegularLabel: UILabel {
    open override var text: String? {
        didSet {
            if let text = text {
                attributedText = dinRegularText(text: text, font: font)
            }
        }
    }
}
