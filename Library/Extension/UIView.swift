//
//  UIView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/1.
//

import Foundation

// MARK: UIView
extension UIView {
    /**
     Set the corner radius of the view.
     
     - Parameter color:        The color of the border.
     - Parameter cornerRadius: The radius of the rounded corner.
     - Parameter borderWidth:  The width of the border.
     */
    open func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func updateSizeConstraint(_ constraint: (NSLayoutConstraint, NSLayoutConstraint)?, _ size: CGSize, widthRange: Int = 0, heightRange: Int = 0) -> (NSLayoutConstraint, NSLayoutConstraint) {
        if let (widthConstraint, heightConstraint) = constraint {
            widthConstraint.constant = size.width
            heightConstraint.constant = size.height
            return (widthConstraint, heightConstraint)
        } else {
            let widthConstraint = updateWidthConstraint(nil, size.width, range: widthRange)
            let heightConstraint = updateHeightConstraint(nil, size.height, range: heightRange)
            return (widthConstraint, heightConstraint)
        }
    }

    func updateWidthConstraint(_ widthConstraint: NSLayoutConstraint?, _ width: CGFloat, range: Int = 0) -> NSLayoutConstraint {
        if let widthConstraint = widthConstraint {
            widthConstraint.constant = width
            return widthConstraint
        } else {
            let widthConstraint: NSLayoutConstraint
            if (range == 0) {
                widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
            } else if (range < 0) {
                widthConstraint = self.widthAnchor.constraint(lessThanOrEqualToConstant: width)
            } else {
                widthConstraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            }
            widthConstraint.isActive = true
            return widthConstraint
        }
    }

    func updateHeightConstraint(_ heightConstraint: NSLayoutConstraint?, _ height: CGFloat, range: Int = 0) -> NSLayoutConstraint {
        if let heightConstraint = heightConstraint {
            heightConstraint.constant = height
            return heightConstraint
        } else {
            let heightConstraint: NSLayoutConstraint
            if (range == 0) {
                heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
            } else if (range < 0) {
                heightConstraint = self.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            } else {
                heightConstraint = self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            }
            heightConstraint.isActive = true
            return heightConstraint
        }
    }


}
