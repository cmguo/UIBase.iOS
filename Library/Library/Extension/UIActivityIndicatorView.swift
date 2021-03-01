//
//  UIActivityIndicatorView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/1.
//

import Foundation

// MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView: IndicatorProtocol {
    public var radius: CGFloat {
        get {
            return self.frame.width/2
        }
        set {
            self.frame.size = CGSize(width: 2*newValue, height: 2*newValue)
            self.setNeedsDisplay()
        }
    }
    
    public var color: UIColor {
        get {
            return self.tintColor
        }
        set {
            let ciColor = CIColor(color: newValue)
            #if os(iOS)
            self.style = newValue.RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue).key > 0.5 ? .gray : .white
            #endif
            self.tintColor = newValue
        }
    }
    // unused
    public func setupAnimation(in layer: CALayer, size: CGSize) {}
}
