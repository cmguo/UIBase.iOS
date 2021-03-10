//
//  Range.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/9.
//

import Foundation

extension Range where Bound == String.Index {
    func nsRange(text: String) -> NSRange {
        return NSRange(location: lowerBound.utf16Offset(in: text),
                       length: upperBound.utf16Offset(in: text) -
                        lowerBound.utf16Offset(in: text))
    }
}
