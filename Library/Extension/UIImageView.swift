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
        self.image = UIImage.transparent
        let icon = CALayer(svgURL: svgURL) { (layer: SVGLayer) in
            let bounds = inBounds ?? layer.frame
            // TODO: scale icon
            layer.frame = bounds.centerPart(ofSize: layer.boundingBox.centerBoundingSize())
            completion?(layer.boundingBox)
        }
        self.layer.addSublayer(icon)
    }
    
    public func setIconColor(color: UIColor) {
        if let sublayers = self.layer.sublayers {
            for sl in sublayers {
                if let svg = sl as? CAShapeLayer {
                    svg.fillColor = color.cgColor
                }
            }
        }
    }

}
