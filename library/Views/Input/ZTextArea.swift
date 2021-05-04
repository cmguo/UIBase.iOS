//
//  ZTextArea.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/9.
//

import Foundation
import SnapKit
import MobileCoreServices

public class MediaTextView: UITextView {

    public var didPasteData: ((Data) -> Void)?
    public var willCopyData: (() -> String?)?

    public override func paste(_ sender: Any?) {
        let pasteBoard = UIPasteboard.general
        let types: [String] = pasteBoard.types
        if types.count > 0 {
            let firstType: String = types[0]
            if firstType == (kUTTypeGIF as String) || firstType == (kUTTypeImage as String) {
                if let data = pasteBoard.data(forPasteboardType: firstType) {
                    didPasteData?(data)
                    return
                }
            }
            if let image = pasteBoard.image, let data = image.jpegData(compressionQuality: 1) {
                didPasteData?(data)
                return
            }
        }
        super.paste(sender)
    }

    public override func copy(_ sender: Any?) {
        UIPasteboard.general.string = willCopyData?()
    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if didPasteData == nil {
            return super.canPerformAction(action, withSender: sender)
        }
        if action == #selector(paste(_:)) {
            let pasteBoard = UIPasteboard.general
            let types: [String] = pasteBoard.types
            if types.count > 0 {
                let firstType: String = types[0]
                if firstType == (kUTTypeGIF as String) || firstType == (kUTTypeImage as String) {
                    return true
                } else if pasteBoard.image != nil {
                    return true
                }
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}

@objc public protocol ZTextAreaDelegate {
    
    @objc optional func textAreaShouldChangeTextInRange(_ textArea: ZTextArea, _ range: NSRange, _ replacementText: String) -> Bool
    @objc optional func textAreaShouldBegainEditing(_ textArea: ZTextArea) -> Bool
    @objc optional func textAreaDidBeginEditing(_ textArea: ZTextArea)
    @objc optional func textAreaDidEndEditing(_ textArea: ZTextArea)

    @objc optional func textAreaIconTapping(_ textArea: ZTextArea, index: Int, holding: Bool)
    @objc optional func textAreaIconTapped(_ textArea: ZTextArea, index: Int)
}


/*
 ZTextArea
   MediaTextView (text)
   UILabel (placeholder)
 */

public class ZTextArea: UIView {
    
    private static let defaultPlaceHolderTextColor = UIColor.bluegrey_500
    private static let defaultWordCountTextColor = UIColor.bluegrey_700
    private static let defaultFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    private static let defaultWordCounFont = UIFont.systemFont(ofSize: 12, weight: .regular) // for word count label
    private static let backgroundColor = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.bluegrey_00, .STATES_NORMAL)
    ])
    private static let borderColor = StateListColor([
        StateColor(.red_500, .STATES_ERROR),
        StateColor(.blue_600, .STATES_FOCUSED),
        StateColor(.bluegrey_300, .STATES_NORMAL)
    ])
    private static let padding: CGFloat = 12
    private static let paddingH: CGFloat = 12 // for single mode
    private static let paddingV: CGFloat = 6 // for single mode
    private static let borderRadius: CGFloat = 8
    private static let borderWidth: CGFloat = 1

    public var leftIcon: URL? {
        didSet {
            setIcon(0, leftIcon)
        }
    }
    
    public var rigthIcon: URL? {
        didSet {
            setIcon(1, rigthIcon)
        }
    }
    
    @objc public var placeholder: String? {
        get { placeholderLabel.text }
        set {
            placeholderLabel.text = newValue
            showPlaceholderIfNeed()
        }
    }

    @objc public var placeholderPrefix: String? {
        didSet {
            if placeholderPrefix != nil {
                placeholderLabel.numberOfLines = 1
                let placeholderPrefixWidth = (placeholderPrefix! as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
                placeholderLabel.snp.updateConstraints { make in
                    make.left.equalTo(6 + placeholderPrefixWidth)
                    make.top.equalTo(0)
                    make.width.lessThanOrEqualTo(self).offset(-12 - placeholderPrefixWidth)
                }
            } else {
                placeholderLabel.snp.updateConstraints { make in
                    make.top.left.equalTo(6)
                    make.width.lessThanOrEqualTo(self).offset(-12)
                }
            }
        }
    }
    
    public var placeholderColor: UIColor {
        get { placeholderLabel.textColor }
        set {
            placeholderLabel.textColor = newValue
        }
    }
    
    @objc public var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
            //showAttributPlaceholderIfNeed()
        }
    }
    
    public var showBorder: Bool = false {
        didSet {
            if showBorder {
                self.layer.borderColor = ZTextArea.borderColor.color(for: states()).cgColor
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

    public var delegate: ZTextAreaDelegate? = nil
    
    public var font: UIFont {
        didSet {
            textView.font = font
        }
    }

    public var returnKeyType: UIReturnKeyType {
        didSet {
            textView.returnKeyType = returnKeyType
        }
    }

    @objc public var text: String {
        get {
            return textView.text
        }
        set {
            if shouldChangeTextIn(range: NSRange(location: 0, length: textView.text.count), with: newValue) {
                textView.text = newValue
            }
        }
    }

    public var maxWords: Int = 0 {
        didSet {
            if maxWords > 0 {
                textView.limitWordCount(maxWords, 0)
                updateWordCount()
                if wordCountLabel.isHidden {
                    wordCountLabel.isHidden = false
                    setNeedsLayout()
                }
            } else if !wordCountLabel.isHidden {
                wordCountLabel.isHidden = true
                setNeedsLayout()
            }
        }
    }

    open override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }

    public var minHeight: CGFloat = 50 {
        didSet { recalcHeight() }
    }
    public var maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude {
        didSet { recalcHeight() }
    }
    
    // MARK: text view
    public let layoutManager: NSLayoutManager
    @objc public let textStorage: NSTextStorage
    public let textContainer: NSTextContainer
    
    fileprivate let textView: MediaTextView
    
    fileprivate lazy var leftImage: UIImageView = createImageView(index: 0)
    
    fileprivate lazy var rightImage: UIImageView = createImageView(index: 1)
    
    fileprivate lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.font = font
        label.textColor = ZTextArea.defaultPlaceHolderTextColor
        addSubview(label)
        optionalViews[2] = label
        return label
    }()
    
    fileprivate lazy var wordCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = ZTextArea.defaultWordCounFont
        label.textColor = ZTextArea.defaultWordCountTextColor
        label.textAlignment = .right
        addSubview(label)
        optionalViews[3] = label
        return label
    }()

    fileprivate let single: Bool
    fileprivate let paddings: UIEdgeInsets
    fileprivate var optionalViews: [UIView?] = [nil, nil, nil, nil]

    public init(single: Bool = false) {
        self.single = single
        
        layoutManager = NSLayoutManager()
        textContainer = NSTextContainer()
        textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.allowsNonContiguousLayout = false
        textContainer.widthTracksTextView = true
        textContainer.maximumNumberOfLines = single ? 1 : 0
        textView = MediaTextView(frame: CGRect.zero, textContainer: textContainer)
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        font = ZTextArea.defaultFont
        textView.font = font
        returnKeyType = UIReturnKeyType.send
        paddings = single ? UIEdgeInsets(top: ZTextArea.paddingV, left: ZTextArea.paddingH, bottom: ZTextArea.paddingV, right: ZTextArea.paddingH) : UIEdgeInsets(top: ZTextArea.padding, left: ZTextArea.padding, bottom: ZTextArea.padding, right: ZTextArea.padding)

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 40))

        initialize()
    }

    private var textViewConstraintMaker: (ConstraintMaker) -> Void = { (maker) in }
    
    private func initialize() {
        self.layer.cornerRadius = ZTextArea.borderRadius
        self.layer.borderWidth = ZTextArea.borderWidth
        self.autoresizesSubviews = true
        
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.textAlignment = NSTextAlignment.left
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero

        addSubview(textView)

        layoutSubviews()
        recalcHeight()

        textView.willCopyData = { [weak self] in
            return self?.textView.getCopyText() ?? ""
        }
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textView.resignFirstResponder()
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    @objc public var cursor: NSRange {
        get {
            return textView.selectedRange
        }
        set {
            textView.selectedRange = newValue
        }
    }

    @objc public func getInputTextView() -> MediaTextView {
        return textView
    }

    public var fieldBackgroundDidTapClosure: ((ZTextArea) -> Void)?

    @objc private func fieldBackgroundDidTap() {
        fieldBackgroundDidTapClosure?(self)
        if textView.inputView != nil {
            textView.inputView = nil
            textView.reloadInputViews()
        }
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        fieldBackgroundDidTap()
        return super.hitTest(point, with: event)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        showPlaceholderIfNeed()
        //showAttributPlaceholderIfNeed()
        let leftImageVisible = optionalViewVisible(0)
        let rightImageVisible = optionalViewVisible(1)
        let placeholderLabelVisible = optionalViewVisible(2)
        let wordCountLabelVisible = optionalViewVisible(3)
        var rect = bounds;
        rect.inset(paddings)
        if wordCountLabelVisible {
            let size = wordCountLabel.sizeThatFits(rect.size)
            if single {
                var r = rect.cutRight(40)
                r.moveLeftCenter(toSize: size)
                wordCountLabel.frame = r
            } else {
                var r = rect.cutBottom(22)
                r.moveTopTo(r.bottom - size.height)
                wordCountLabel.frame = r
            }
        }
        if (leftImageVisible) {
            let r = rect.cutLeft(leftImage.frame.width + 4)
            leftImage.frame = r.leftCenterPart(ofSize: leftImage.bounds.size)
        }
        if (rightImageVisible) {
            let r = rect.cutRight(rightImage.frame.width + 4)
            rightImage.frame = r.rightCenterPart(ofSize: rightImage.frame.size)
        }
        textView.frame = rect
        if placeholderLabelVisible {
            let size = placeholderLabel.sizeThatFits(rect.size)
            rect.height2 = size.height
            placeholderLabel.frame = rect
        }
    }
    
    fileprivate func optionalViewVisible(_ index: Int) -> Bool {
        if let v = optionalViews[index] {
            return !v.isHidden
        }
        return false
    }

    fileprivate func createImageView(index: Int) -> UIImageView {
        let imageView = UIImageView()
        addSubview(imageView)
        optionalViews[index] = imageView
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTap(_:)))
        imageView.addGestureRecognizer(recognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    @objc fileprivate func imageViewTap(_ recognizer: UITapGestureRecognizer) {
        let index = optionalViews.firstIndex(of: recognizer.view)!
        if recognizer.state == .began {
            delegate?.textAreaIconTapping?(self, index: index, holding: true)
        } else if recognizer.state == .cancelled {
            delegate?.textAreaIconTapping?(self, index: index, holding: false)
        } else if recognizer.state == .ended {
            delegate?.textAreaIconTapping?(self, index: index, holding: false)
            delegate?.textAreaIconTapped?(self, index: index)
        }
    }
    
    fileprivate func setIcon(_ index: Int, _ icon: URL?) {
        let hidden = !optionalViewVisible(index)
        if let icon = icon {
            let imageView = index == 0 ? leftImage : rightImage
            imageView.setImage(withURL: icon) {
                imageView.isHidden = false
                self.setNeedsLayout()
            }
        } else if let view = optionalViews[index] {
            view.isHidden = true
            if !hidden {
                setNeedsLayout()
            }
        }
    }

    fileprivate func showPlaceholderIfNeed() {
        if let label = optionalViews[2] {
            if textView.hasText {
                if placeholderPrefix != nil && textView.getTextAndSegmentContext().0 == placeholderPrefix! {
                    label.isHidden = false
                } else {
                    label.isHidden = true
                }
            } else {
                label.isHidden = false
            }
        }
    }
    
    fileprivate func states() -> UIControl.State {
        var states = UIControl.State.STATES_NORMAL
        if isFocused {
            states = states.union(.STATE_FOCUSED)
        }
        return states
    }

    fileprivate func updateWordCount() {
        guard self.maxWords > 0 else { return }
        let count = text.count
        if count > 0 {
            let string = String(format: "%d/%d", count, self.maxWords)
            self.wordCountLabel.text = string
        } else {
            self.wordCountLabel.text = " "
        }
    }
    
    fileprivate func recalcHeight() {
        let rect = layoutManager.usedRect(for: textContainer)
        if textView.bounds.height != rect.size.height {
            var height = rect.size.height
            height -= textView.frame.height
            height += self.bounds.height
            if !single {
                if height > maxHeight {
                    height = maxHeight
                } else if height < minHeight {
                    height = minHeight
                }
            }
            var bounds = self.bounds
            bounds.size.height = height
            self.bounds = bounds
            superview?.setNeedsLayout()
        }
    }
    
}

extension ZTextArea: UITextViewDelegate {

    public func textViewDidBeginEditing(_: UITextView) {
        delegate?.textAreaDidBeginEditing?(self)
    }

    public func textViewDidEndEditing(_: UITextView) {
        delegate?.textAreaDidEndEditing?(self)
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        textView.layoutIfNeeded()
        if let selectedTextRange = textView.selectedTextRange {
            var caretRect = textView.caretRect(for: selectedTextRange.end)
            caretRect.size.height += textView.textContainerInset.bottom
            textView.scrollRectToVisible(caretRect, animated: false)
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        if maxWords > 0 {
            if single {
                self.textView.limitWordCount(maxWords, 0)
            }
            self.updateWordCount()
        }
        recalcHeight()
        if let selectedTextRange = textView.selectedTextRange {
            if #available(iOS 9.0, *) {
                let line = textView.caretRect(for: selectedTextRange.start)
                let overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top)

                if overflow > 0 && overflow != .infinity {
                    textView.scrollRangeToVisible(textView.selectedRange)
                    textView.isScrollEnabled = false
                    textView.isScrollEnabled = true
                }
            } else {
                textView.scrollRangeToVisible(textView.selectedRange)
            }
        }

        showPlaceholderIfNeed()
        //showAttributPlaceholderIfNeed()
    }

    public func textView(_: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate?.textAreaShouldChangeTextInRange?(self, range, text) ?? true
    }

    public func textViewShouldBeginEditing(_: UITextView) -> Bool {
        return delegate?.textAreaShouldBegainEditing?(self) ?? true
    }
}

extension ZTextArea {


    private func shouldChangeTextIn(range: NSRange, with text: String) -> Bool {
        return delegate?.textAreaShouldChangeTextInRange?(self, range, text) ?? true
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if #available(iOS 9.0, *) {
            let menuController = UIMenuController.shared
            let wrapItem = UIMenuItem(title: "换行", action: #selector(wrap(_:)))
            menuController.menuItems = [wrapItem]
            return (action == #selector(wrap(_:)))
        } else {
            return false
        }
    }

    @objc func wrap(_ sender: Any?) {
        textView.wrap()
    }
}
