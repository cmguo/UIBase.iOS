//
//  XHBNumberView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/1.
//

import Foundation

public class XHBNumberView : UIControl, UITextFieldDelegate {

    public var minimum = 0 {
        didSet {
            if (oldValue == minimum) { return }
            if (minimum < 0) { minimum = oldValue; return }
            if (maximum > 0 && maximum < minimum) {
                maximum = minimum
            }
            if (number < minimum) {
                number = minimum
            } else {
                syncEnable()
            }
        }
    }

    public var maximum = 0 {
        didSet {
            if (oldValue == maximum) { return }
            if (maximum > 0 && maximum < minimum) {
                minimum = maximum
            }
            if (maximum > 0 && maximum < number) {
                number = maximum
            } else {
                syncEnable()
            }
        }
    }

    public var step = 1 {
        didSet { syncEnable() }
    }

    public var wraps = false {
        didSet { syncEnable() }
    }

    public var autoRepeat = false {
        didSet {
            if (autoRepeat) {
                _buttonDec.removeTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
                _buttonInc.removeTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
                _buttonDec.addGestureRecognizer(_repeatGestureDec!)
                _buttonInc.addGestureRecognizer(_repeatGestureInc!)
            } else {
                _buttonDec.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
                _buttonInc.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
                _buttonDec.removeGestureRecognizer(_repeatGestureDec!)
                _buttonInc.removeGestureRecognizer(_repeatGestureInc!)
            }
        }
    }

    public var continues = true

    public var number = 0 { //数量
        didSet {
            if (oldValue == number || (maximum > 0 && maximum < number) || number < minimum) {
                return
            }
            if (!_inCallbacks) {
                _editText.text = String(number)
            }
            syncEnable()
            setNeedsLayout()
            if (continues || !_inInteraction) {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    private let _buttonInc = XHBButton()
    private let _buttonDec = XHBButton()
    private let _editText = UITextField()
    private let _style: XHBNumberViewStyle
    
    private var _repeatGestureDec: UIGestureRecognizer? = nil
    private var _repeatGestureInc: UIGestureRecognizer? = nil

    private var _inCallbacks = false
    private var _inInteraction = false

    public init(style: XHBNumberViewStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.viewStyle = style
        _editText.textAppearance = style.textAppearance
        _editText.backgroundColor = .clear
        _editText.textAlignment = .center
        _editText.keyboardType = .numberPad
        _buttonDec.icon = .icon_minus
        _buttonInc.icon = .icon_plus
        _buttonInc.buttonAppearance = style.buttonAppearance
        _buttonDec.buttonAppearance = style.buttonAppearance

        addSubview(_editText)
        addSubview(_buttonDec)
        addSubview(_buttonInc)

        _editText.text = String(number)
        syncEnable()

        _editText.delegate = self
        _repeatGestureDec = UIRepeatTapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        _repeatGestureInc = UIRepeatTapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        _buttonDec.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        _buttonInc.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)

        _ = updateSizeConstraint(nil, style.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            return true
        }
        guard let value = Int(String(newText)), value >= minimum && (maximum == 0 || value <= maximum) else {
            return false
        }
        _inCallbacks = true
        number = value
        _inCallbacks = false
        return true
    }
    
    public override func layoutSubviews() {
        var frame = bounds
        frame.deflate(_style.padding)
        _buttonDec.frame = frame.cutLeft(frame.height)
        _buttonInc.frame = frame.cutRight(frame.height)
        var size = _editText.sizeThatFits(frame.size)
        size.width = frame.width
        _editText.frame = frame.centerPart(ofSize: size)
    }
    
    /* private */
    
    @objc private func buttonClick(_ sender: UIView) {
        _editText.endEditing(true)
        if (sender == _buttonDec) {
            if (number >= minimum + step) {
                number -= step
            } else if (wraps && maximum > 0) {
                var n = number - step
                while (n < minimum) {
                    n += maximum - minimum + 1
                }
                number = n
            }
        } else if (sender == _buttonInc) {
            if (maximum == 0 || number + step <= maximum) {
                number += step
            } else if (wraps && maximum > 0) {
                var n = number + step
                while (n > maximum) {
                    n -= maximum - minimum + 1
                }
                number = n
            }
        }
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        let inInteraction = sender.state != .ended && sender.state != .cancelled
        if inInteraction {
            _inInteraction = inInteraction
            buttonClick(sender.view!)
        } else if _inInteraction {
            _inInteraction = inInteraction
            if !continues {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    private func syncEnable() {
        let w = wraps && maximum > 0
        _buttonDec.isEnabled = w || number >= minimum + step
        _buttonInc.isEnabled = w || (maximum == 0) || (number + step <= maximum)
    }

}
