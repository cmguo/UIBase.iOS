//
//  ZTabBar.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation
import JXSegmentedView

public protocol ZTabBarIndicatorProtocol : JXSegmentedIndicatorProtocol {
    
}

public protocol ZTabBarDelegate : JXSegmentedViewDelegate {
    
}

public class ZTabBar : JXSegmentedView {
    
    public var titles: [Any] = [] {
        didSet {
            syncTitles()
        }
    }
    
    public var icons: [Any?]? = nil {
        didSet {
            syncTitles()
        }
    }
    
    public var indicator: (UIView & ZTabBarIndicatorProtocol)? = nil {
        didSet {
            super.indicators = indicator == nil ? [] : [indicator!]
        }
    }
    
    /* private properties */
    
    private let _style: ZTabBarStyle
    
    public init(style: ZTabBarStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.collectionView.viewStyle = style.titleStyle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _dataSource: JXSegmentedTitleDataSource? = nil
    
    private func syncTitles() {
        let dataSource: JXSegmentedTitleDataSource
        if let icons = icons {
            let ds = JXSegmentedTitleImageDataSource()
            ds.titleImageType = .rightImage
            ds.normalImageInfos = icons.map { i in i == nil ? "" : "\(i!)" }
            ds.loadImageClosure = {(imageView, normalImageInfo) in
                imageView.image = UIImage(named: normalImageInfo)
            }
            dataSource = ds
        } else {
            dataSource = JXSegmentedTitleDataSource()
        }
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalFont = _style.titleStyle.textAppearence.font
        dataSource.titleNormalColor = _style.titleStyle.textAppearence.textColor
        dataSource.titleSelectedColor = _style.titleStyle.textAppearence.textColors.color(for: .selected)
        dataSource.isTitleZoomEnabled = _style.titleStyle.textSizeSelected > 0
        dataSource.titleSelectedZoomScale = _style.titleStyle.textSizeSelected / _style.titleStyle.textAppearence.textSize
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.isSelectedAnimable = true
        dataSource.titles = self.titles.map { t in "\(t)" }
        _dataSource = dataSource
        self.dataSource = dataSource
    }
    
}
