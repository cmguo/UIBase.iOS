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
        }
    }
    
    open var image: UIImage? = nil {
        didSet {
            
        }
    }

    /// Badge's height, Badge's cornerRadius is half of the value
    public var height: CGFloat = 9 {
        didSet {
            updateHeight()
        }
    }

    /// Badge's center position relative to the parent view's center position displacement
    /// A positive x means moving to the right
    /// A positive y means moving to the bottom
    public var offset: CGPoint = .zero {
        didSet {
            remakeConstraints()
        }
    }

    open var badgeColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }

    open var insets: CGSize = CGSize(width: 6, height: 2) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open var cornerRadius: CGFloat = -1 {
        didSet {
            setNeedsDisplay()
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

    open override func draw(_ rect: CGRect) {

        let actualCornerRadius = cornerRadius >= 0 ? cornerRadius : rect.height / 2

        var path: UIBezierPath?

        if actualCornerRadius == 0 {
            path = UIBezierPath(rect: rect)
        } else {
            path = UIBezierPath(roundedRect: rect, cornerRadius: actualCornerRadius)
        }

        badgeColor.setFill()
        path?.fill()

        super.draw(rect)
    }

    private func setup() {
        textAlignment = NSTextAlignment.center
        clipsToBounds = false
    }
    
    
    private func remakeConstraints() {
        guard self.superview != nil else {
            return
        }
        updateCenterXConstraint()
        updateCenterYConstraint()
        updateHeightConstraint()
        updateWidthConstraint()
        updateCornerRadius()
    }

    private func updateHeight() {
        updateHeightConstraint()
        updateWidthConstraint()
        updateCornerRadius()
    }

    private var centerXConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?

    private func updateCenterXConstraint() {
        guard let superView = self.superview else {
            return
        }
        if let centerXConstraint = centerXConstraint {
            centerXConstraint.constant = offset.x
        } else {
            centerXConstraint = self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: offset.x)
            centerXConstraint?.isActive = true
        }
    }

    private func updateCenterYConstraint() {
        guard let superView = self.superview else {
            return
        }
        if let centerYConstraint = centerYConstraint {
            centerYConstraint.constant = offset.y
        } else {
            centerYConstraint = self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: offset.y)
            centerYConstraint?.isActive = true
        }
    }
    private func updateHeightConstraint() {
        if let heightConstraint = heightConstraint {
            heightConstraint.constant = height
        } else {
            heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
            heightConstraint?.isActive = true
        }
    }

    private func updateWidthConstraint() {
        let width: CGFloat
        if let string = self.text, !string.isEmpty {
            width = string.boundingSize(with: CGSize.zero, font: self.font).width
        } else {
            width = height
        }
        if let widthConstraint = widthConstraint {
            widthConstraint.constant = width
        } else {
            widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
            widthConstraint?.isActive = true
        }
    }


    private func updateCornerRadius() {
        if cornerRadius >= 0 {
            self.layer.cornerRadius = cornerRadius
        } else {
            self.layer.cornerRadius = height / 2
        }
    }


}
