//
//  UIImageView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation
import SwiftSVG

extension UIImageView {
    
    public func setImage(withURL url: URL?, completion: ( () -> Void)? = nil) {
        if url?.pathExtension == "svg" {
            setSvgIcon(svgURL: url, completion: completion)
        } else {
            if let sublayers = self.layer.sublayers {
                for sl in sublayers {
                    sl.removeFromSuperlayer()
                }
            }
            image = url == nil ? nil : UIImage(withUrl: url!)
            completion?()
        }
    }

    public func setSvgIcon(svgURL : URL?, completion: ( () -> Void)? = nil) {
        setSvgIcon(svgURL: svgURL, inBounds: nil, completion: completion)
    }
    
    public func setSvgIcon(svgURL : URL?, inBounds: CGRect?, completion: ( () -> Void)?) {
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
        let icon = CALayer(svgURL: svgURL) { (layer: SVGLayer) in
            let bounds = inBounds ?? self.bounds
            if bounds.isEmpty {
                let bounds = layer.boundingBox.centerBounding()
                self.bounds = bounds
                layer.frame = bounds
            } else {
                let size = layer.boundingBox.centerBoundingSize()
                let scale = min(bounds.width / size.width, bounds.height / size.height)
                layer.transform = CATransform3DMakeScale(scale, scale, 1)
                layer.frame = bounds//.centerPart(ofSize: size)
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
        self.layer.addSublayer(icon)
    }
    
    public func setIconColor(color: UIColor) {
        self.layer.applyOnSublayers(ofType: CAShapeLayer.self) { (thisShapeLayer: CAShapeLayer) in
            thisShapeLayer.fillColor = color.cgColor
        }
    }

}
