//
//  KeyboardWatcher.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/19.
//

import Foundation
import UIKit

public class KeyboardWatcher : NSObject {
    
    public static let shared = KeyboardWatcher()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private var _view: UIView? = nil
    private var _scrollState: CGFloat = 0

    @objc func keyboardWillShow(_ n: Notification) {
        guard let view = _view else {
            return
        }
        let value = n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let height = value.cgRectValue.size.height + 20
        let duration = n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        if _scrollState != 0 {
            view.scrollUpRestore(_scrollState)
        }
        _scrollState = view.scrollUp(contentBottom: view.bounds.height, toWindowY: view.window!.bounds.bottom - height, withDuration: duration.doubleValue)
    }
    
    @objc func keyboardWillHide(_ n: Notification) {
        guard let view = _view else {
            return
        }
        view.scrollUpRestore(_scrollState)
        _scrollState = 0
    }

    func active(view: UIView) {
        _view = view
    }
    
    func deactive(view: UIView) {
        if _view == view {
            view.scrollUpRestore(_scrollState)
            _scrollState = 0
        }
    }

}
