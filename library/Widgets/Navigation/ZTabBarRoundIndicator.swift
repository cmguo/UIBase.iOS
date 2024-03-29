//
//  ZTabBarRoundIndicator.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

import JXSegmentedView

public class ZTabBarRoundIndicator : JXSegmentedIndicatorBackgroundView, ZTabBarIndicatorProtocol {
    
    public init(style: ZTabBarRoundIndicatorStyle = .init()) {
        super.init(frame: .zero)
        super.applyStyle(style)
        layer.shadowRadius = style.shadowRadius
        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
