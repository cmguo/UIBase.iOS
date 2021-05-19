//
//  ZTextView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

public class ZTextView : UITextView {
    
    public var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var maxWordCount: Int = 0 {
        didSet {
            if maxWordCount > 0, let text = text, maxWordCount < text.count {
                self.text = text[0..<maxWordCount]
            }
        }
    }
    
    open var singleLine = false {
        didSet {
            _textContainer.maximumNumberOfLines = singleLine ? 1 : 0
        }
    }
    
    public override var delegate: UITextViewDelegate? {
        didSet {
            _delegate.delegate = delegate
            super.delegate = oldValue
        }
    }
    
    public override var contentSize: CGSize {
        didSet {
            updateHeight()
        }
    }

    /* private properties */
    
    private var _style: ZTextViewStyle
    
    private let _textStorage = NSTextStorage()
    private let _layoutManager = NSLayoutManager()
    private let _textContainer = NSTextContainer()
    private let _delegate = ZTextViewDelegate()
    private let _placeholderAttrs: [NSAttributedString.Key:Any]

    
    public init(style: ZTextViewStyle = .init()) {
        _style = style
        _placeholderAttrs = [
            NSAttributedString.Key.font: _style.textAppearance.font,
            NSAttributedString.Key.foregroundColor: _style.placeholderTextColor
        ]
        _textStorage.addLayoutManager(_layoutManager)
        _layoutManager.addTextContainer(_textContainer )
        super.init(frame: .zero, textContainer: _textContainer)
        super.textViewStyle = style
        super.delegate = _delegate
        super.addDoneButton(title: "完成", target: self, selector: #selector(inputFinish(_:)))

        let menuController = UIMenuController.shared
        let wrapItem = UIMenuItem(title: "换行", action: #selector(wrap(_:)))
        menuController.menuItems = [wrapItem]
        
        self.textContainerInset = _style.padding
        updateHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        viewStyle = _style
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let ph = placeholder as NSString?, text.isEmpty {
            // draw placeholder
            var point = rect.leftTop
            point.x += contentInset.left
            point.y += contentInset.top
            point.x += textContainerInset.left
            point.y += textContainerInset.top
            point.x += textContainer.lineFragmentPadding
            ph.draw(at: point, withAttributes: _placeholderAttrs)
        }
    }

    /* private */
    
    @objc private func wrap(_ sender: Any?) {
        self.wrap()
    }
    
    @objc private func inputFinish(_ sender: UIView) {
        endEditing(true)
    }

    private var _heightConstraint: NSLayoutConstraint? = nil
    
    private func updateHeight() {
        let height = contentInset.top + contentSize.height + contentInset.bottom
        _heightConstraint = updateHeightConstraint(_heightConstraint, height, range: 1)
    }
}


class UITextViewDelegateWrapper : NSObject, UITextViewDelegate {
    
    var delegate: UITextViewDelegate? = nil
    
    @available(iOS 2.0, *)
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool { // return NO to disallow editing.
        return delegate?.textViewShouldBeginEditing?(textView) ?? true
    }

    @available(iOS 2.0, *)
    func textViewDidBeginEditing(_ textView: UITextView) { // became first responder
        delegate?.textViewDidBeginEditing?(textView)
    }

    @available(iOS 2.0, *)
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool { // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return delegate?.textViewShouldEndEditing?(textView) ?? true
    }

    @available(iOS 2.0, *)
    func textViewDidEndEditing(_ textView: UITextView) { // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        delegate?.textViewDidEndEditing?(textView)
    }

    
    @available(iOS 2.0, *)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool { // return NO to not change text
        return delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: string) ?? true
    }
    
    @available(iOS 2.0, *)
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange?(textView)
    }
    
    @available(iOS 10.0, *)
    func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }

    
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
    }

    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
}

class ZTextViewDelegate : UITextViewDelegateWrapper {
    
    @available(iOS 2.0, *)
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool { // return NO to not change text
        if !super.textView(textView, shouldChangeTextIn: range, replacementText: string) {
            return false
        }
        if let tf = textView as? ZTextView, let text = tf.text,
           tf.maxWordCount < text.count - range.length + string.count {
            return false
        }
        return true
    }
    
    override func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if !super.textViewShouldBeginEditing(textView) {
            return false
        }
        // first textViewDidBeginEditing is later than keyboard notify
        KeyboardWatcher.shared.active(view: textView)
        return true
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        KeyboardWatcher.shared.deactive(view: textView)
        super.textViewDidEndEditing(textView)
    }

    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        if let tf = textView as? ZTextView {
            tf.setNeedsDisplay()
        }
    }
}
