//
//  ZTextInput.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

@objc public protocol ZTextInputDelegate {
    @objc optional func textInput(_ textArea: ZTextInput, buttonTapping id: ZButton.ButtonId, holding: Bool)
    @objc optional func textInput(_ textArea: ZTextInput, buttonTapped id: ZButton.ButtonId)
}


public class ZTextInput : ZTextView {
    
    public var leftButton: Any? {
        didSet {
            syncButton(_leftButton, leftButton)
        }
    }
    
    public var rightButton: Any? {
        didSet {
            syncButton(_rightButton, rightButton)
        }
    }
    
    open override var maxWordCount: Int {
        didSet {
            syncWordCount()
        }
    }
    
    open override var singleLine: Bool {
        didSet {
            syncPadding()
        }
    }
    
    public var textInputDelegate: ZTextInputDelegate? = nil {
        didSet {
            if let delegate = textInputDelegate as? UITextViewDelegate {
                super.delegate = delegate
            } else if (super.delegate === oldValue) {
                super.delegate = nil
            }
        }
    }
    
    private lazy var _leftButton: ZButton = self.createButton(.Left)
    private lazy var _rightButton: ZButton = self.createButton(.Right)
    private lazy var _placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAppearance = _style.textAppearance
        label.textColor = _style.placeholderTextColor
        self.addSubview(label)
        return label
    }()
    private lazy var _wordCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAppearance = _style.wordCountLabelAppearance
        self.addSubview(label)
        return label
    }()
    
    private let _style: ZTextInputStyle
    private let _delegate = ZTextInputDelegateWrapper()
    
    public init(style: ZTextInputStyle = .init()) {
        _style = style
        super.init(style: style)
        super.delegate = _delegate
        
        syncButton(_leftButton, leftButton)
        syncButton(_rightButton, rightButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        var frame = bounds
        frame.inset(_style.padding)
        let buttonAppearance = _style.buttonAppearance
        if maxWordCount > 0 {
            let size = _wordCountLabel.bounds.size
            if singleLine {
                frame.height2 = buttonAppearance.height!
                _wordCountLabel.frame = frame.cutRight(size.width + buttonAppearance.iconPadding!).rightCenterPart(ofSize: size)
            } else {
                _wordCountLabel.frame = frame.cutBottom(size.height + buttonAppearance.iconPadding!).rightBottomPart(ofSize: size)
            }
        }
        if leftButton != nil {
            _leftButton.frame = frame.cutLeft(buttonAppearance.iconSize! + buttonAppearance.iconPadding!).leftTopPart(ofSize: _leftButton.bounds.size)
        }
        if rightButton != nil {
            _rightButton.frame = frame.cutRight(buttonAppearance.iconSize! + buttonAppearance.iconPadding!).rightTopPart(ofSize: _rightButton.bounds.size)
        }
        //_placeholderLabel.frame = frame
    }
    
    /* private */
    
    @objc private func buttonTouchDown(_ sender: UIView) {
        textInputDelegate?.textInput?(self, buttonTapping: (sender as! ZButton).id!, holding: true)
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIView) {
        textInputDelegate?.textInput?(self, buttonTapping: (sender as! ZButton).id!, holding: false)
        textInputDelegate?.textInput?(self, buttonTapped: (sender as! ZButton).id!)
    }
    
    @objc private func buttonTouchUpOutside(_ sender: UIView) {
        textInputDelegate?.textInput?(self, buttonTapping: (sender as! ZButton).id!, holding: false)
    }
    
    private func createButton(_ id: ZButton.ButtonId) -> ZButton {
        let button = ZButton()
        button.buttonAppearance = _style.buttonAppearance
        button.id = id
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpOutside(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }
    
    private func syncButton(_ button: ZButton, _ content: Any?) {
        button.content = content
        syncPadding()
    }
    
    fileprivate func syncWordCount() {
        _wordCountLabel.text = "\(text.count)/\(maxWordCount)"
        _wordCountLabel.isHidden = maxWordCount == 0
        syncPadding()
    }
    
    private func syncPadding() {
        var padding = _style.padding
        let buttonAppearance = _style.buttonAppearance
        if leftButton != nil {
            padding.left += buttonAppearance.iconSize! + buttonAppearance.iconPadding!
        }
        if rightButton != nil {
            padding.right += buttonAppearance.iconSize! + buttonAppearance.iconPadding!
        }
        if maxWordCount > 0 {
            _wordCountLabel.sizeToFit()
            let size = _wordCountLabel.bounds.size
            if singleLine {
                padding.right += size.width + buttonAppearance.iconPadding!
            } else {
                padding.bottom += size.height + buttonAppearance.iconPadding!
            }
        }
        textContainerInset = padding
        setNeedsLayout()
        setNeedsDisplay()
    }
}

class ZTextInputDelegateWrapper : UITextViewDelegateWrapper {
    
    override func textViewDidChange(_ textView: UITextView) {
        if let ti = textView as? ZTextInput {
            ti.syncWordCount()
        }
    }
}
