//
//  ZTabBarLineIndicator.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation
import JXSegmentedView

public class ZTabBarLineIndicator : JXSegmentedIndicatorLineView, ZTabBarIndicatorProtocol {
    
    public init(style: ZTabBarLineIndicatorStyle = .init()) {
        super.init(frame: .zero)
        super.applyStyle(style)
        verticalOffset = style.offsetY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

