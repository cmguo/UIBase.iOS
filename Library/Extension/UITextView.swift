//
//  UITextView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/10.
//

import Foundation

extension UITextView {
    
    open var textViewStyle: UITextViewStyle {
        get { return UITextViewStyle() }
        set {
            super.viewStyle = newValue
            textAppearance = newValue.textAppearance
        }
    }
    
    var textAppearance: TextAppearance {
        get { return textViewStyle.textAppearance }
        set {
            font = newValue.font
            textColor = newValue.textColor
        }
    }
    
    func limitWordCount(_ maxWords: Int, _ position: Int) {
        if markedTextRange == nil {
            //DispatchQueue.main.async {
                let text: String = self.text
                if text.count > maxWords {
                    let range = text.rangeOfComposedCharacterSequence(at: text.index(text.startIndex, offsetBy: maxWords - 1)).nsRange(text: text)
                    let lastLength = range.location + range.length
                    if let attributedText = self.attributedText, attributedText.length > lastLength {
                        // TODO: erase before position
                        self.attributedText = attributedText.attributedSubstring(from: NSRange(location: 0, length: lastLength))
                        self.undoManager?.removeAllActions()
                    }
                }
            //}
        }
    }

}
