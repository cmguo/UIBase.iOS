//
//  ZTabBarIndicator.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation
import JXSegmentedView

extension JXSegmentedIndicatorBaseView {
    
    func applyStyle(_ style: ZTabBarIndicatorStyle) {
        switch (style.widthMode) {
        case .MatchCell:
            indicatorWidth = JXSegmentedViewAutomaticDimension
            isIndicatorWidthSameAsItemContent = false
            indicatorWidthIncrement = -style.width * 2
        case .MatchContent:
            indicatorWidth = JXSegmentedViewAutomaticDimension
            isIndicatorWidthSameAsItemContent = true
            indicatorWidthIncrement = -style.width * 2
        case .Exactly:
            indicatorWidth = style.width
            isIndicatorWidthSameAsItemContent = false
            indicatorWidthIncrement = 0
        }
        indicatorHeight = style.height <= 0 ? JXSegmentedViewAutomaticDimension : style.height
        indicatorColor = style.color
        indicatorCornerRadius = style.radius // JXSegmentedViewAutomaticDimension
    }
}
