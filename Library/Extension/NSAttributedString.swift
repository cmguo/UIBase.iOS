//
//  NSAttributedString.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/7/15.
//

import Foundation

public protocol TextOwner : NSObject {
    
    var attributedText2: NSAttributedString? { get set }
    
    var font2: UIFont? { get }
    
    var text2: String? { get }
}


public extension TextOwner {
    
    var textStyle: TextStyle {
        get { return TextStyle() }
        set {
            textFont = newValue.font
            if newValue.lineHeight > 0 {
                lineHeight = newValue.lineHeight
            }
            if newValue.lineSpacing > 0 {
                lineSpacing = newValue.lineSpacing
            }
            textAlignment2 = newValue.textAlignment
        }
    }

    var textAppearance: TextAppearance {
        get { return TextAppearance() }
        set {
            textStyle = newValue
            textForegroundColor = newValue.textColor
            textBackgroundColor = newValue.backgroundColor
        }
    }

    var textForegroundColor: UIColor? {
        get { getAttribute(.foregroundColor) }
        set { setAttribute(.foregroundColor, value: newValue) }
    }

    var textBackgroundColor: UIColor? {
        get { getAttribute(.backgroundColor) }
        set { setAttribute(.backgroundColor, value: newValue) }
    }

    var textFont: UIFont? {
        get { getAttribute(.font) }
        set { setAttribute(.font, value: newValue) }
    }

    var lineHeight: CGFloat? {
        get { attributedText2?.paragraphStyle?.maximumLineHeight }
        set {
            let lineHeight = newValue ?? 0.0
            if let font = textFont ?? font2 {
                let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0
                setAttribute(.baselineOffset, value: baselineOffset)
            }
            attributedText2 = (attributedText2 ?? NSMutableAttributedString(string: text2 ?? " ", attributes: nil)).set(lineHeight: lineHeight)
            observeIfNeeded()
        }
    }
    
    var lineSpacing: CGFloat? {
        get { attributedText2?.paragraphStyle?.lineSpacing }
        set {
            setParagraphStyleProperty(newValue, for: \.lineSpacing)
        }
    }
    
    var textAlignment2: NSTextAlignment? {
        get { attributedText2?.paragraphStyle?.alignment }
        set {
            setParagraphStyleProperty(newValue, for: \.alignment)
        }
    }

    var letterSpacing: CGFloat? {
        get { getAttribute(.kern) }
        set { setAttribute(.kern, value: newValue) }
    }

    var underline: NSUnderlineStyle? {
        get { getAttribute(.underlineStyle) }
        set { setAttribute(.underlineStyle, value: newValue) }
    }
    
    var strikethrough: NSUnderlineStyle? {
        get { getAttribute(.textEffect) }
        set { setAttribute(.strikethroughStyle, value: newValue) }
    }
}

extension TextOwner {
    
    fileprivate func getAttribute<AttributeType>(_ key: NSAttributedString.Key) -> AttributeType? {
        return attributedText2?.getAttribute(key)
    }

    fileprivate func setAttribute<AttributeType>(_ key: NSAttributedString.Key, value: AttributeType?) {
        if let value = value {
            attributedText2 = (attributedText2 ?? NSMutableAttributedString(string: text2 ?? " ", attributes: nil)).addAttribute(key, value: value)
        } else {
            attributedText2 = attributedText2?.removeAttribute(key)
        }
        observeIfNeeded()
    }
    
    fileprivate func setParagraphStyleProperty<ValueType>(
        _ value: ValueType?,
        for keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, ValueType>) {
        attributedText2 = (attributedText2 ?? NSMutableAttributedString(string: text2 ?? " ", attributes: nil)).setParagraphStyleProperty(value, for: keyPath)
        observeIfNeeded()
    }
}

extension NSAttributedString {
        
    fileprivate var entireRange: NSRange {
        NSRange(location: 0, length: self.length)
    }

    fileprivate var attributes: [NSAttributedString.Key : Any] {
        get {
            return self.length == 0 ? [:] : attributes(at: 0, effectiveRange: nil)
        }
    }

    fileprivate func getAttribute<AttributeType>(_ key: NSAttributedString.Key) -> AttributeType? where AttributeType: Any {
        return attributes[key] as? AttributeType
    }
    
    fileprivate func getAttribute<AttributeType>(_ key: NSAttributedString.Key) -> AttributeType? where AttributeType: OptionSet {
        if let attribute = attributes[key] as? AttributeType.RawValue {
            return .init(rawValue: attribute)
        } else {
            return nil
        }
    }

    fileprivate func addAttribute<AttributeType>(_ key: NSAttributedString.Key, value: AttributeType) -> NSAttributedString where AttributeType: Any {
        let mutableAttributedText = (self as? NSMutableAttributedString) ?? NSMutableAttributedString(attributedString: self)
        mutableAttributedText.addAttribute(key, value: value, range: entireRange)
        return mutableAttributedText
    }
    
    fileprivate func addAttribute<AttributeType>(_ key: NSAttributedString.Key, value: AttributeType) -> NSAttributedString where AttributeType: OptionSet {
        let mutableAttributedText = (self as? NSMutableAttributedString) ?? NSMutableAttributedString(attributedString: self)
        mutableAttributedText.addAttribute(key, value: value.rawValue, range: entireRange)
        return mutableAttributedText
    }
    
    fileprivate func removeAttribute(_ key: NSAttributedString.Key) -> NSAttributedString {
        let mutableAttributedText = (self as? NSMutableAttributedString) ?? NSMutableAttributedString(attributedString: self)
        mutableAttributedText.removeAttribute(key, range: entireRange)
        return mutableAttributedText
    }
    
}

extension NSAttributedString {
    
    fileprivate var paragraphStyle: NSParagraphStyle? {
        getAttribute(.paragraphStyle)
    }
    
    fileprivate func setParagraphStyleProperty<ValueType>(
        _ value: ValueType?,
        for keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, ValueType>
    ) -> NSAttributedString {
        let mutableParagraphStyle = paragraphStyle as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        if let paragraphyStyle = paragraphStyle, paragraphStyle !== mutableParagraphStyle {
            mutableParagraphStyle.setParagraphStyle(paragraphyStyle)
        }
        if let value = value {
            mutableParagraphStyle[keyPath: keyPath] = value
        }
        return addAttribute(.paragraphStyle, value: mutableParagraphStyle)
    }
}

extension NSAttributedString {
    
    fileprivate func set(lineHeight: CGFloat) -> NSAttributedString {
        return setParagraphStyleProperty(lineHeight, for: \.minimumLineHeight)
            .setParagraphStyleProperty(lineHeight, for: \.maximumLineHeight)
    }
}

fileprivate class TextObserver: NSObject {
    
    private weak var object: TextOwner?
    fileprivate var attributes: [NSAttributedString.Key : Any]?
    
    init(for object: TextOwner) {
        self.object = object
        self.attributes = object.attributedText2?.attributes
        super.init()
        object.addObserver(self, forKeyPath: "text", options: .new, context: &Keys.observer)
    }
    
    deinit {
        object?.removeObserver(self, forKeyPath: "text")
    }
    
    fileprivate func updateAttributes() {
        self.attributes = object?.attributedText2?.attributes
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.object?.onTextChange(attributes)
    }
}

fileprivate struct Keys {
    static var observer: UInt8 = 0
}

extension TextOwner {
        
    fileprivate var observer: TextObserver? {
        get {
            objc_getAssociatedObject(self, &Keys.observer) as? TextObserver
        }
        set {
            objc_setAssociatedObject(self, &Keys.observer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func observeIfNeeded() {
        if let observer = observer {
            observer.updateAttributes()
            return
        }
        observer = TextObserver(for: self)
    }
    
    fileprivate func onTextChange(_ attributes: [NSAttributedString.Key : Any]?) {
        if let text = text2 {
            self.attributedText2 = NSAttributedString(string: text, attributes: attributes)
        }
    }
}
