//
//  UITextView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/10.
//

import Foundation

public extension UITextView {
    
    var textViewStyle: UITextViewStyle {
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

    
    @objc func append(image: UIImage, imageSize size: CGSize, altName alt: String?) {
        let imageAttachment = ImageTextAttachment()
        imageAttachment.alt = alt
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -(size.height - font!.pointSize) / 2 - 2, width: size.width, height: size.height)
        append(imageAttachment: imageAttachment)
    }

    @objc func append(imageAttachment attachment: NSTextAttachment) {
        self.textStorage.beginEditing()
        let currentIndexLength = self.textStorage.length
        let imageAttributeString = NSAttributedString(attachment: attachment)
        self.textStorage.replaceCharacters(in: self.selectedRange, with: imageAttributeString)
        self.textStorage.endEditing()
        let range = NSRange(location: 0, length: self.textStorage.length)
        if currentIndexLength == 0 || self.selectedRange.location > 0 {
            self.textStorage.beginEditing()
            self.textStorage.addAttribute(NSAttributedString.Key.font, value: self.font!, range: range)
            self.textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: self.textColor ?? UIColor.black, range: range)
            self.textStorage.endEditing()
        }
        self.selectedRange = NSRange(location: self.selectedRange.location + 1, length: 0)
        delegate?.textViewDidChange?(self)
    }

    @objc func append(segmentText text: String?, additionData context: Dictionary<String, Any>? = nil) {
        if let text = text, let image = generateImage(from: text) {
            let attachment = SegmentTextAttachment()
            attachment.alt = text
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -(image.size.height - font!.pointSize) / 2 - 2, width: image.size.width, height: image.size.height)
            attachment.additionalData = context
            append(imageAttachment: attachment)
        }
    }

    @objc func append(_ text: String) {
        if let should = delegate?.textView?(self, shouldChangeTextIn: NSRange(location: textStorage.length, length: 0), replacementText: text), !should {
            return
        }
        textStorage.beginEditing()
        textStorage.append(NSAttributedString(string: text))
        if let font = font {
            let range = NSRange(location: 0, length: textStorage.length)
            textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? UIColor.black, range: range)
        }
        textStorage.endEditing()
        selectedRange = NSRange(location: textStorage.length, length: 0)
        delegate?.textViewDidChange?(self)
    }

    @objc func insert(text: String, range: NSRange) {
        if let should = delegate?.textView?(self, shouldChangeTextIn: NSRange(location: textStorage.length, length: 0), replacementText: text), !should {
            return
        }
        textStorage.beginEditing()
        textStorage.insert(NSAttributedString(string: text), at: range.location)
        if let font = font {
            let range = NSRange(location: 0, length: textStorage.length)
            textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? UIColor.black, range: range)
        }
        textStorage.endEditing()
        let newRange = NSRange(location: range.location + text.count, length: 0)
        selectedRange = newRange
        delegate?.textViewDidChange?(self)
    }

    func generateImage(from text: String) -> UIImage? {
        var size: CGSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font!])
        let maxWidth: CGFloat = max(frame.width - 50, 100)
        size = CGSize(width: CGFloat(min(maxWidth, size.width)), height: CGFloat(size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIColor.black.set()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        text.draw(in: CGRect(x: 0, y: 0, width: CGFloat(size.width), height: CGFloat(size.height)), withAttributes: [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func getCopyText() -> String {
        var result = String()
        textStorage.enumerateAttributes(in: selectedRange) { attrs, range, _ in
            if let attachment = attrs[NSAttributedString.Key.attachment] {
                if let textAttachment = attachment as? SegmentTextAttachment {
                    result += textAttachment.alt ?? ""
                } else if let imageAttachment = attachment as? ImageTextAttachment {
                    result += imageAttachment.alt ?? ""
                }
            } else {
                let item = attributedText.attributedSubstring(from: range).string
                result += item
            }
        }
        return result
    }

    func getTextAndSegmentContext() -> (String, [[String: Any]]) {
        var result = String()
        var context = [[String: Any]]()
        textStorage.enumerateAttributes(in: NSRange(location: 0, length: textStorage.length)) { attrs, range, _ in
            if let attachment = attrs[NSAttributedString.Key.attachment] {
                if let textAttachment = attachment as? SegmentTextAttachment {
                    result += textAttachment.alt ?? ""
                    if textAttachment.additionalData != nil {
                        context.append(textAttachment.additionalData!)
                    }
                } else if let imageAttachment = attachment as? ImageTextAttachment {
                    result += imageAttachment.alt ?? ""
                }
            } else {
                let item = attributedText.attributedSubstring(from: range).string
                result += item
            }
        }
        return (result, context)
    }

    @objc var richTextValue: String {
        return getTextAndSegmentContext().0
    }

    @objc func replace(range: NSRange, text: String) {
        if range.length + range.location > textStorage.length {
            return
        }
        textStorage.beginEditing()
        textStorage.replaceCharacters(in: range, with: text)
        textStorage.endEditing()
        selectedRange = NSRange(location: range.location + text.count, length: 0)
    }
    
    @objc func replace(range: NSRange, image: UIImage, imageSize size: CGSize, altName alt: String?) {
        if range.length + range.location > textStorage.length {
            return
        }
        let imageAttachment = ImageTextAttachment()
        imageAttachment.alt = alt
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -(size.height - font!.pointSize) / 2 - 2, width: size.width, height: size.height)
        textStorage.beginEditing()
        textStorage.addAttribute(NSAttributedString.Key.font, value: font!, range: NSRange(location: 0, length: textStorage.length))
        textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: self.textColor ?? UIColor.black,
                                 range: NSRange(location: 0, length: textStorage.length))
        let imageAttributeString = NSAttributedString(attachment: imageAttachment)
        textStorage.replaceCharacters(in: range, with: imageAttributeString)
        textStorage.endEditing()
        selectedRange = NSRange(location: textStorage.length, length: 0)
    }

    @objc func wrap() {
        insert(text: "\n", range: selectedRange)
    }
}

