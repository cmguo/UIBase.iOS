//
//  UIView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/1.
//

import Foundation

extension UIView {
    
    open var viewStyle: UIViewStyle {
        get { return .Default }
        set {
            layer.backgroundColor = newValue.backgroundColor.cgColor
            layer.cornerRadius = newValue.cornerRadius
            layer.borderWidth = newValue.borderWidth
            layer.borderColor = newValue.borderColor.cgColor
        }
    }
    
}

extension UIView {
    
    func subview<T: UIView>(ofType type: T.Type) -> T? {
        for v in subviews {
            if let vt = v as? T {
                return vt
            }
            if let vt = v.subview(ofType: type) {
                return vt
            }
        }
        return nil
    }
    
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext();
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

extension UIView {

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
    
    func widthConstraint() -> (Int, CGFloat) {
        return dimenConstraint(widthAnchor, bounds.width)
    }
    
    func heightConstraint() -> (Int, CGFloat) {
        return dimenConstraint(heightAnchor, bounds.height)
    }
    
    func dimenConstraint(_ dimen: NSLayoutDimension, _ size: CGFloat) -> (Int, CGFloat) {
        var range = 0
        var value = size
        for c in constraints {
            if c.firstAnchor == dimen  {
                switch c.relation {
                case .equal:
                    value = c.constant
                case .greaterThanOrEqual:
                    range = 1
                    value = c.constant
                case .lessThanOrEqual:
                    range = -1
                    value = c.constant
                @unknown default:
                    break;
                }
            }
        }
        return (range, value)
    }


}
