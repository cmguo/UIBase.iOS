//
//  ShapeLayers.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

class ShapeLayer : CALayer {
    
    struct Config {
        let shape: Int = 0
        let radius: CGFloat = 0
        let fillColorList: StateListColor? = nil
        let fillColor: UIColor? = nil
        let borderSize: CGFloat = 0
        let borderColorList: StateListColor? = nil
        let borderColor: UIColor? = nil
        let width: CGFloat = 0
        let height: CGFloat = 0
    }
    
    private let fillColorList: StateListColor?
    private let borderColorList: StateListColor?

    init(config: Config) {
        self.fillColorList = config.fillColorList
        self.borderColorList = config.borderColorList
        super.init()
        if config.width > 0 && config.height > 0 {
            self.frame = CGRect(x: 0, y: 0, width: config.width, height: config.height)
        }
        self.cornerRadius = config.radius
        self.borderWidth = config.borderSize
        if (config.fillColorList == nil) {
            backgroundColor = config.fillColor?.cgColor
        }
        if (config.borderColorList == nil) {
            backgroundColor = config.borderColor?.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStates(states: Int) {
        if fillColorList != nil {
            backgroundColor = fillColorList?.color(for: states).cgColor
        }
        if borderColorList != nil {
            borderColor = borderColorList?.color(for: states).cgColor
        }
    }
}
