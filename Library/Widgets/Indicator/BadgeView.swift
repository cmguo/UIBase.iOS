//
//  BadgeView.swift
//  Demo
//
//  Created by iOS-马振宇 on 2021/3/9.
//

import Foundation
import UIKit

/*  具体使用范例
 let unReadMessageCountBadge: BadgeView = {
     let badge = BadgeView()
     badge.cornerRadius = 8
     badge.minBadgeSize = CGSize(width: 16, height: 16)
     badge.badgeColor = ThemeColor.shared.red_500
     badge.textColor = ThemeColor.shared.static_white_100
     badge.font = systemFontSize(fontSize: 11)
     return badge
 }()
 */

open class BadgeView: UILabel {

    open var badgeColor: UIColor = .red {
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

    //没有数字的小红点最小值
    open var minBadgeSize: CGSize = .zero {
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
}
