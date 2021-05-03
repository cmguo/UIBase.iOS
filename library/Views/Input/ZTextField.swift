//
//  ZTextField.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/2.
//

import Foundation

public class ZTextField : UITextField {
    
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
    
    public override var placeholder: String? {
        didSet {}
    }

    public var maxWords: Int = 0 {
        didSet {
            if maxWords > 0, let text = text, maxWords < text.count {
                self.text = text[0..<maxWords]
            }
        }
    }
    
    public override var delegate: UITextFieldDelegate? {
        didSet {
            _delegate.delegate = delegate
            super.delegate = oldValue
        }
    }

    /* private properties */
    
    private var _style: ZTextFieldStyle
    
    private let _delegate = ZTextFieldDelegate()
    private lazy var _leftButton: ZButton = self.createButton(.Left)
    private lazy var _rightButton: ZButton = self.createButton(.Right)
    
    public init(style: ZTextFieldStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.textFieldStyle = style
        super.delegate = _delegate
        
        syncButton(_leftButton, leftButton)
        syncButton(_rightButton, rightButton)
        
        _ = updateHeightConstraint(nil, _style.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonClicked(_ sender: UIView) {
        
    }
    
    private func createButton(_ id: ZButton.ButtonId) -> ZButton {
        let button = ZButton()
        button.buttonAppearance = _style.buttonAppearance
        button.id = id
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        if id == .Left {
            self.leftView = button
            self.leftViewMode = .always
        } else {
            self.rightView = button
            self.rightViewMode = .always
        }
        return button
    }
    
    private func syncButton(_ button: ZButton, _ content: Any?) {
        button.content = content
        button.isUserInteractionEnabled = content != nil
    }
}

class ZTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    var delegate: UITextFieldDelegate? = nil
    
    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { // return NO to disallow editing.
        return delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        delegate?.textFieldDidBeginEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return delegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidEndEditing(_ textField: UITextField) { // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        delegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) { // if implemented, called in place of textFieldDidEndEditing:
        delegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    @available(iOS 2.0, *)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        if let should = delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string), !should {
            return false
        }
        if let tf = textField as? ZTextField, let text = tf.text,
           tf.maxWords < text.count - range.length + string.count {
            return false
        }
        return true
    }
    
    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChangeSelection?(textField)
    }
    
    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool { // called when clear button pressed. return NO to ignore (no notifications)
        return delegate?.textFieldShouldClear?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // called when 'return' key pressed. return NO to ignore.
        return delegate?.textFieldShouldReturn?(textField) ?? true
    }
    
}
