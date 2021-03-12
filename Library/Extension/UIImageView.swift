//
//  UIImageView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation
import SwiftSVG

extension UIImageView {

    public func setIcon(svgURL : URL?, completion: ( (CGRect) -> Void)?) {
        setIcon(svgURL: svgURL, inBounds: nil, completion: completion)
    }
    
    public func setIcon(svgURL : URL?, inBounds: CGRect?, completion: ( (CGRect) -> Void)?) {
        if let sublayers = self.layer.sublayers {
            for sl in sublayers {
                sl.removeFromSuperlayer()
            }
        }
        guard let svgURL = svgURL else {
            completion?(CGRect.zero)
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
                completion?(layer.boundingBox)
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
