//
//  UIImageView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation
import SwiftSVG

extension UIImageView {

    public func setImage(wild: Any?, completion: (() -> Void)? = nil) {
        if let url = wild as? URL {
            setImage(withURL: url, completion: completion)
        } else {
            setImage(svgURL: nil) {
            }
            if let image = wild as? UIImage {
                self.image = image
            } else if let color = wild as? UIColor {
                self.image = UIImage.from(color: color)
            } else if let view = wild as? UIView {
                if view.bounds.isEmpty {
                    view.sizeToFit()
                }
                self.image = view.snapshot()
            } else {
                self.image = nil
            }
        }
    }

    public func setImage(withURL url: URL?, completion: (() -> Void)? = nil) {
        if url?.pathExtension == "svg" {
            self.image = nil
            setImage(svgURL: url, completion: completion)
        } else {
            setImage(svgURL: nil) {
            }
            image = url == nil ? nil : UIImage(withUrl: url!)
            completion?()
        }
    }

    public func setImage(svgURL: URL?, completion: (() -> Void)? = nil) {
        setImage(svgURL: svgURL, inBounds: nil, completion: completion)
    }

    public func setImage(svgURL: URL?, inBounds: CGRect?, completion: (() -> Void)?) {
        if let sublayers = self.layer.sublayers {
            for sl in sublayers {
                sl.removeFromSuperlayer()
            }
        }
        guard let svgURL = svgURL else {
            completion?()
            return
        }
        //self.image = UIImage.transparent
        let icon = CALayer(SVGURL: svgURL) { [weak self] (layer: SVGLayer) in
            DispatchQueue.main.async { // delay for all state ready
                guard let self = self else { return }
                let bounds = inBounds ?? self.bounds
                if bounds.isEmpty {
                    let bounds = layer.boundingBox.centerBounding()
                    self.bounds = bounds
                    layer.frame = bounds
                } else {
                    let size = layer.boundingBox.centerBoundingSize()
                    let scale = min(bounds.width / size.width, bounds.height / size.height)
                    layer.superlayer?.transform = CATransform3DMakeScale(scale, scale, 1)
                    layer.frame = bounds//.centerPart(ofSize: size)
                }
                completion?()
                self.applyIconColor()
            }
        }
        self.layer.addSublayer(icon)
    }

    public func setIconColor(color: UIColor) {
        self.layer.applyOnSublayers(ofType: CAShapeLayer.self) { (thisShapeLayer: CAShapeLayer) in
            thisShapeLayer.fillColor = color.cgColor
        }
        iconColor = color
    }

    public func updateSvgScale(_ oldSize: CGSize, _ newSize: CGSize) {
        if let layers = self.layer.sublayers {
            for l in layers {
                let svg = l.sublayers(in: l) as [SVGLayer]
                if !svg.isEmpty {
                    var size2 = oldSize
                    var scale = l.transform.m11
                    size2.width /= scale
                    size2.height /= scale
                    scale = min(newSize.width / size2.width, newSize.height / size2.height)
                    l.transform = CATransform3DMakeScale(scale, scale, 1)
                }
            }
        }
    }

    private static let iconColor = ObjectAssociation<UIColor>()

    private var iconColor: UIColor? {
        get {
            return UIImageView.iconColor[self] ?? nil
        }
        set {
            UIImageView.iconColor[self] = newValue
        }
    }

    private func applyIconColor() {
        if let color = iconColor {
            setIconColor(color: color)
        }
    }
}
