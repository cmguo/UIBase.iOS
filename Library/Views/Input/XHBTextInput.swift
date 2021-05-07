//
//  XHBTextInput.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/3.
//

import Foundation

public class XHBTextInput : XHBTextView {
    
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
    
    private lazy var _leftButton: XHBButton = self.createButton(.Left)
    private lazy var _rightButton: XHBButton = self.createButton(.Right)
    private lazy var _wordCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAppearance = _style.wordCountLabelAppearance
        self.addSubview(label)
        return label
    }()
    
    private let _style: XHBTextInputStyle
    private let _delegate = XHBTextInputDelegate()
    
    public init(style: XHBTextInputStyle = .init()) {
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
        let sizeStyle = _style.buttonAppearance.sizeStyle
        if maxWordCount > 0 {
            let size = _wordCountLabel.bounds.size
            if singleLine {
                frame.height2 = sizeStyle.height
                _wordCountLabel.frame = frame.cutRight(size.width + sizeStyle.iconPadding).rightCenterPart(ofSize: size)
            } else {
                _wordCountLabel.frame = frame.cutBottom(size.height + sizeStyle.iconPadding).rightBottomPart(ofSize: size)
            }
        }
        if leftButton != nil {
            _leftButton.frame = frame.cutLeft(sizeStyle.iconSize + sizeStyle.iconPadding).leftTopPart(ofSize: _leftButton.bounds.size)
        }
        if rightButton != nil {
            _rightButton.frame = frame.cutRight(sizeStyle.iconSize + sizeStyle.iconPadding).rightTopPart(ofSize: _rightButton.bounds.size)
        }
    }
    
    /* private */
    
    @objc private func buttonClicked(_ sender: UIView) {
        
    }
    
    private func createButton(_ id: XHBButton.ButtonId) -> XHBButton {
        let button = XHBButton()
        button.buttonAppearance = _style.buttonAppearance
        button.id = id
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }
    
    private func syncButton(_ button: XHBButton, _ content: Any?) {
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
        let sizeStyle = _style.buttonAppearance.sizeStyle
        if leftButton != nil {
            padding.left += sizeStyle.iconSize + sizeStyle.iconPadding
        }
        if rightButton != nil {
            padding.right += sizeStyle.iconSize + sizeStyle.iconPadding
        }
        if maxWordCount > 0 {
            _wordCountLabel.sizeToFit()
            let size = _wordCountLabel.bounds.size
            if singleLine {
                padding.right += size.width + sizeStyle.iconPadding
            } else {
                padding.bottom += size.height + sizeStyle.iconPadding
            }
        }
        textContainerInset = padding
        setNeedsLayout()
        setNeedsDisplay()
    }
}

class XHBTextInputDelegate : UITextViewDelegateWrapper {
    
    override func textViewDidChange(_ textView: UITextView) {
        if let ti = textView as? XHBTextInput {
            ti.syncWordCount()
        }
    }
}
