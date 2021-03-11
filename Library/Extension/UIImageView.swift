//
//  UIImageView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation
import SwiftSVG

extension UIImageView {
    
    public func setIcon(svgURL : URL?, completion: @escaping (CGRect) -> Void) {
        if let sublayers = self.layer.sublayers {
            for sl in sublayers {
                sl.removeFromSuperlayer()
            }
        }
        guard let svgURL = svgURL else {
            completion(CGRect.zero)
            return
        }
        self.image = UIImage.transparent
        let icon = CALayer(svgURL: svgURL) { (layer: SVGLayer) in
            completion(layer.boundingBox)
        }
        self.layer.addSublayer(icon)
    }

}
