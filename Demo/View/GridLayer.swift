//
//  GridLayer.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/12.
//

import Foundation
import SwiftUI

class GridLayer : CAShapeLayer {
    
    override init() {
        super.init()
        fillColor = nil
        strokeColor = UIColor.lightGray.cgColor
        lineWidth = 0.25
        path = Self.createPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let WIDTH: CGFloat = 16
    
    static func createPath() -> CGPath {
        let path = CGMutablePath()
        var bounds = UIScreen.main.bounds
        let top = bounds.top
        bounds.moveTopTo(bounds.top + WIDTH)
        while (bounds.top < bounds.bottom) {
            path.move(to: bounds.leftTop)
            path.addLine(to: bounds.rightTop)
            bounds.moveTopTo(bounds.top + WIDTH)
        }
        bounds.moveTopTo(top)
        bounds.moveLeftTo(bounds.left + WIDTH)
        while (bounds.left < bounds.right) {
            path.move(to: bounds.leftTop)
            path.addLine(to: bounds.leftBottom)
            bounds.moveLeftTo(bounds.left + WIDTH)
        }
        return path
    }
    
}
