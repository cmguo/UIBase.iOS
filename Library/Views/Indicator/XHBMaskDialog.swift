//
//  XHBMaskDialog.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

public class XHBMaskDialog : UIView, UIGestureRecognizerDelegate {
    
    private let content: UIView
    private let gravity: Int
    
    init(content: UIView, gravity: Int = Gravity.BOTTOM) {
        self.content = content
        self.gravity = gravity
        super.init(frame: .zero)
        backgroundColor = .gray

        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(window: UIWindow) {
        frame = window.bounds
        window.addSubview(self)
        addSubview(content)
    }
    
    public func dismiss() {
        removeFromSuperview()
    }
    
    public class func dismiss(content: UIView) {
        (content.superview as? Self)?.dismiss()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = self.bounds
        let cw = content.widthConstraint()
        let ch = content.heightConstraint()
        var cBounds = CGRect(origin: .zero, size: CGSize(width: cw.1, height: ch.1))
        if (gravity & Gravity.BOTTOM) != 0 {
            cBounds.bottom = bounds.bottom
        } else if (gravity & Gravity.TOP) != 0 {
            cBounds.top = bounds.top
        } else {
            cBounds.centerY = bounds.centerY
        }
        if (gravity & Gravity.CENTER_HORIZONTAL) == 0 {
            cBounds.left = bounds.left
            cBounds.width2 = bounds.width
        } else {
            cBounds.centerX = bounds.centerX
        }
        content.frame = cBounds
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer? = nil) {
        removeFromSuperview()
    }
    
}
