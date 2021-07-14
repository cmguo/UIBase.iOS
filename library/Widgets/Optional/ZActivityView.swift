//
//  ZActivityView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation

@objc public protocol ZActivityViewDelegate {
    @objc optional func activityViewButtonClicked(view: ZActivityView, line: Int, index: Int)
}

public class ZActivityView : UIView {

    public var items1: [Any] = [] {
        didSet {
            _line1.items = items1
            syncSize()
        }
    }
    
    public var items2: [Any] = [] {
        didSet {
            _line2.items = items2
            syncSize()
        }
    }
    
    public var callback: ZActivityViewDelegate? = nil

    private let _line1: ZActivityLine
    private let _line2: ZActivityLine
    
    private let _style: ZActivityViewStyle
    
    public init(style: ZActivityViewStyle = .init()) {
        _style = style
        _line1 = ZActivityLine(style: style)
        _line2 = ZActivityLine(style: style)
        super.init(frame: .zero)
        
        addSubview(_line1)
        addSubview(_line2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        var frame = bounds
        if !items1.isEmpty {
            _line1.frame = frame.cutTop(_line1.bounds.height)
        }
        if !items2.isEmpty {
            _line2.frame = frame
        }
    }
    
    private var _constraint: (NSLayoutConstraint, NSLayoutConstraint)? = nil
    
    private func syncSize() {
        var size = CGSize.zero
        size.width = UIScreen.main.bounds.size.width
        if !items1.isEmpty {
            size.height += _line1.bounds.height
        }
        if !items2.isEmpty {
            size.height += _line2.bounds.height
        }
        _constraint = updateSizeConstraint(_constraint, size, widthRange: -1)
    }
    
    @objc fileprivate func buttonClicked(_ sender: UIView) {
        let lineView = sender.superview
        let line = lineView == _line1 ? 0 : 1
        let index = lineView?.subviews.firstIndex(of: sender)
        callback?.activityViewButtonClicked?(view: self, line: line, index: index!)
    }
    
}

public class ZActivityLine: UIScrollView {

    public var items: [Any] = [] {
        didSet {
            syncItems()
        }
    }
    
    private let _style: ZActivityViewStyle
    
    public init(style: ZActivityViewStyle) {
        _style = style
        super.init(frame: .zero)
        showsHorizontalScrollIndicator = false
        isPagingEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func syncItems() {
        var frame = CGRect(origin: .zero, size: CGSize(width: _style.itemWidth, height: _style.buttonApperance.height!))
        frame.left = _style.itemPaddingX
        frame.top = _style.itemPaddingY
        var buttons = subviews as! [ZButton]
        buttons.forEach { v in v.removeFromSuperview() }
        for i in items {
            let button = buttons.isEmpty ? createButton() : buttons.removeLast()
            button.content = i
            button.frame = frame
            addSubview(button)
            frame.left += _style.itemWidth + _style.itemPadding
        }
        frame.right = frame.left + _style.itemPaddingX - _style.itemPadding
        frame.moveLeftTopTo(.zero)
        frame.height2 += _style.itemPaddingY
        contentSize = frame.size
        bounds = frame
    }
    
    open func createButton() -> ZButton {
        let button = ZActionButton()
        button.buttonAppearance = _style.buttonApperance
        button.addTarget(superview, action: #selector(ZActivityView.buttonClicked(_:)), for: .touchUpInside)
        return button
    }

}

