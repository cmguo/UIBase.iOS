//
//  ZActionSheet.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation

@objc public protocol ZActionSheetDelegate {
    @objc optional func actionSheet(_ actionSheet: ZActionSheet, onAction index: Int)
}

public class ZActionSheet : UIView {
    
    public var icon: URL? = nil {
        didSet {
            _imageView.setImage(withURL: icon)
            syncSize()
        }
    }
    
    public var title: String? {
        get { return _label.text }
        set {
            _label.text = newValue
            syncSize()
        }
    }
    
    public var subTitle: String? {
        get { return _label2.text }
        set {
            _label2.text = newValue
            syncSize()
        }
    }
    
    public var buttons: [Any] = [] {
        didSet {
            syncButtons()
            syncSize()
        }
    }
    
    public var states: [UIControl.State?]? = nil {
        didSet {
            syncButtons()
        }
    }
    
    public var delegate: ZActionSheetDelegate? = nil
    
    private let _imageView = UIImageView()
    private let _label = UILabel()
    private let _label2 = UILabel()
    private let _spplitter = UIView()

    private var _buttons: [ZButton] = []
    
    private let _style: ZActionSheetStyle
    
    public init(style: ZActionSheetStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        addSubview(_imageView)
        _label.textAppearance = _style.textAppearance
        _label.numberOfLines = 1
        addSubview(_label)
        _label2.textAppearance = _style.textAppearance2
        _label2.numberOfLines = 0
        _label2.textAlignment = .center
        addSubview(_label2)
        _spplitter.backgroundColor = .bluegrey_100
        addSubview(_spplitter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        var frame = bounds
        if icon != nil || title != nil || subTitle != nil {
            frame.top += _style.paddingY
        }
        if icon != nil {
            _imageView.frame = frame.cutTop(_style.iconPadding + _style.iconSize)
                .bottomCenterPart(ofSize: CGSize(width: _style.iconSize, height: _style.iconSize))
        }
        if title != nil {
            _label.frame = frame.cutTop(_style.titlePadding + _label.bounds.height)
                .bottomCenterPart(ofSize: _label.bounds.size)
        }
        if subTitle != nil {
            _label2.frame = frame.cutTop(_label2.bounds.height)
                .bottomCenterPart(ofSize: _label2.bounds.size)
        }
        if frame.height < bounds.height {
            _ = frame.cutTop(_style.titlePadding)
            _spplitter.frame = frame.cutTop(1)
        } else {
            _spplitter.frame = .zero
        }
        for b in _buttons {
            b.frame = frame.cutTop(_style.buttonApperance.sizeStyle.height)
        }
    }
    
    private var _constraint: (NSLayoutConstraint, NSLayoutConstraint)? = nil

    private func syncSize() {
        var size = CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        if icon != nil {
            size.height += _style.iconPadding + _style.iconSize
        }
        if title != nil {
            _label.sizeToFit()
            size.height += _style.titlePadding  + _label.bounds.height
        }
        if subTitle != nil {
            _label2.sizeToFit()
            size.height += _label2.bounds.height
        }
        if size.height > 0 {
            size.height += _style.paddingY + 1 + _style.titlePadding // spplitter
        }
        size.height += _style.buttonApperance.sizeStyle.height * CGFloat(buttons.count)
        _constraint = updateSizeConstraint(_constraint, size, widthRange: -1)
    }
    
    private func syncButtons() {
        while _buttons.count < buttons.count {
            let button = ZButton()
                .buttonAppearance(_style.buttonApperance)
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            addSubview(button)
            _buttons.append(button)
        }
        while buttons.count < _buttons.count {
            let button = _buttons.removeLast()
            button.removeFromSuperview()
        }
        for i in 0..<buttons.count {
            let button = _buttons[i]
            let state = i < (states?.count ?? 0) ? states?[i] : nil
            let enabled = !(state?.contains(.disabled) ?? false)
            let selected = state?.contains(.selected) ?? false
            button.content = buttons[i]
            button.isEnabled = enabled
            button.isSelected = selected
        }
    }
    
    @objc fileprivate func buttonClicked(_ sender: UIView) {
        let index = subviews.firstIndex(of: sender)! - 4
        delegate?.actionSheet?(self, onAction: index)
    }

}
