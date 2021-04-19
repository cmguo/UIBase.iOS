//
//  BadgeButton.swift
//  VideoPlayer-Swift
//
//  Created by kingxt on 2017/4/11.
//  Copyright © 2017年 kingxt. All rights reserved.
//

import Foundation
import UIKit

open class XHBBadgeView: UILabel {

    public var maximum: Int = 0 {
        didSet {
            if number > 0 {
                text = maximum == 0 || number < maximum ? String(number) : "\(maximum)+"
            }
        }
    }
    
    public var number: Int = 0 {
        didSet {
            text = maximum == 0 || number < maximum ? String(number) : "\(maximum)+"
            isHidden = number == 0
        }
    }
    
    open override var text: String? {
        didSet {
            isHidden = false
            updateSize()
        }
    }
    
    open var image: UIImage? = nil {
        didSet {
            
        }
    }

    public var padding: CGFloat = 2 {
        didSet {
            updateSize()
        }
    }
    
    public var gravity: Int = Gravity.RIGHT | Gravity.TOP {
        didSet {
            updateGravity()
        }
    }

    /// Badge's gravity position relative to the parent view's gravity position displacement
    /// A positive x means moving to the right
    /// A positive y means moving to the bottom
    public var offset: CGPoint = .zero {
        didSet {
            updateGravity()
        }
    }

    open var fillColor: UIColor = .red {
        didSet {
            layer.backgroundColor = fillColor.cgColor
            setNeedsDisplay()
        }
    }

    open var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }

    open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }

    open var cornerRadius: CGFloat = -1 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsDisplay()
        }
    }

    open var insets: CGSize = CGSize(width: 6, height: 2) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open var minBadgeSize: CGSize = CGSize.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var roundedOnlyContainOneCharacter = true

    public convenience init() {
        self.init(frame: CGRect())
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func attach(_ target: UIView) {
        target.addSubview(self)
        remakeConstraints()
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)

        let result = rect.insetBy(dx: -insets.width, dy: -insets.height)

        if roundedOnlyContainOneCharacter && text?.count == 1 {
            let limit = max(max(result.size.width, minBadgeSize.width), max(result.size.height, minBadgeSize.height))
            return CGRect(origin: rect.origin, size: CGSize(width: ceil(limit), height: ceil(limit)))
        }
        
        return CGRect(origin: rect.origin, size: CGSize(width: max(result.size.width, minBadgeSize.width), height: max(result.size.height, minBadgeSize.height)))
    }

    open override func drawText(in rect: CGRect) {
        if cornerRadius >= 0 {
            layer.cornerRadius = cornerRadius
        } else {
            layer.cornerRadius = rect.height / 2
        }

        if roundedOnlyContainOneCharacter && text?.count == 1 {
            super.drawText(in: rect)
        } else {
            let insets = UIEdgeInsets(
                top: self.insets.height,
                left: self.insets.width,
                bottom: self.insets.height,
                right: self.insets.width)
            let rectWithoutInsets = rect.inset(by: insets)
            super.drawText(in: rectWithoutInsets)
        }
    }

    private func setup() {
        textAlignment = NSTextAlignment.center
        font = UIFont.systemFont(ofSize: 10, weight: .regular)
        textColor = .white
        clipsToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = fillColor.cgColor
        layer.borderColor = borderColor.cgColor
    }
    
    private func remakeConstraints() {
        guard self.superview != nil else {
            return
        }
        updateSize()
        updateGravity()
    }

    private func updateSize() {
        var size: CGSize
        if let string = text, !string.isEmpty {
            size = string.boundingSize(font: font)
            size.width += padding * 2
            size.height += padding * 2
            if size.width < size.height {
                size.width = size.height
            }
        } else {
            size = CGSize(width: 8, height: 8)
        }
        sizeConstraint = updateSizeConstraint(sizeConstraint, size)
        updateCornerRadius(size)
    }

    private func updateGravity() {
        updateGravityXConstraint()
        updateGravityYConstraint()
    }
    
    private var gravityXConstraint: NSLayoutConstraint?
    private var gravityYConstraint: NSLayoutConstraint?
    private var sizeConstraint: (NSLayoutConstraint, NSLayoutConstraint)? = nil

    private func updateGravityXConstraint() {
        guard let superView = self.superview else {
            return
        }
        let anchor: NSLayoutXAxisAnchor
        let anchor2: NSLayoutXAxisAnchor
        if (gravity & Gravity.LEFT) != 0 {
            anchor = self.leftAnchor
            anchor2 = superView.leftAnchor
        } else if (gravity & Gravity.CENTER_HORIZONTAL) != 0 {
            anchor = self.centerXAnchor
            anchor2 = superView.centerXAnchor
        } else if (gravity & Gravity.RIGHT) != 0 {
            anchor = self.rightAnchor
            anchor2 = superView.rightAnchor
        } else {
            anchor = self.rightAnchor
            anchor2 = superView.rightAnchor
        }
        if let gravityXConstraint = gravityXConstraint, gravityXConstraint.firstAnchor == anchor {
            gravityXConstraint.constant = offset.x
        } else {
            gravityXConstraint?.isActive = false
            gravityXConstraint = anchor.constraint(equalTo: anchor2, constant: offset.x)
            gravityXConstraint?.isActive = true
        }
    }

    private func updateGravityYConstraint() {
        guard let superView = self.superview else {
            return
        }
        let anchor: NSLayoutYAxisAnchor
        let anchor2: NSLayoutYAxisAnchor
        if (gravity & Gravity.TOP) != 0 {
            anchor = self.topAnchor
            anchor2 = superView.topAnchor
        } else if (gravity & Gravity.CENTER_VERTICAL) != 0 {
            anchor = self.centerYAnchor
            anchor2 = superView.centerYAnchor
        } else if (gravity & Gravity.BOTTOM) != 0 {
            anchor = self.bottomAnchor
            anchor2 = superView.bottomAnchor
        } else {
            anchor = self.topAnchor
            anchor2 = superView.topAnchor
        }
        if let gravityYConstraint = gravityYConstraint, gravityXConstraint?.firstAnchor == anchor {
            gravityYConstraint.constant = offset.y
        } else {
            gravityYConstraint?.isActive = false
            gravityYConstraint = anchor.constraint(equalTo: anchor2, constant: offset.y)
            gravityYConstraint?.isActive = true
        }
    }

    private func updateCornerRadius(_ size: CGSize) {
        if cornerRadius >= 0 {
            self.layer.cornerRadius = cornerRadius
        } else {
            self.layer.cornerRadius = size.height / 2
        }
    }


}
