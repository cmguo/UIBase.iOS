//
//  XHBAppTitleBar.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation


@objc public protocol XHBTitleBarCallbackDelegate {
    @objc optional func titleBarButtonClicked(titleBar: XHBAppTitleBar, btnId: XHBButton.ButtonId?)
}


public class XHBAppTitleBar : UIView
{

    public var leftButton: Any? {
        didSet {
            if (leftButton == nil) {
                if oldValue != nil {
                    _leftButton.isHidden = true
                }
            } else {
                _leftButton.content = leftButton
                _leftButton.isHidden = false
            }
            syncSize()
        }
    }
    
    public var rightButton: Any? {
        didSet {
            if (rightButton == nil) {
                if oldValue != nil {
                    _rightButton.isHidden = true
                }
            } else {
                _rightButton.content = rightButton
                _rightButton.isHidden = false
            }
            syncSize()
        }
    }
    
    public var rightButton2: Any? {
        didSet {
            if (rightButton2 == nil) {
                if oldValue != nil {
                    _rightButton2.isHidden = true
                }
            } else {
                _rightButton2.content = rightButton2
                _rightButton2.isHidden = false
            }
            syncSize()
        }
    }
    
    public var icon: URL? {
        didSet {
            _iconView.setImage(withURL: icon)
            syncSize()
        }
    }
    
    public var title: String = "" {
        didSet {
            _titleLabel.text = title
            setNeedsLayout()
        }
    }
    
    public var content: Any? = nil {
        didSet {
            syncContent()
        }
    }
    
    public var textAppearance: TextAppearance? = nil
    
    public var delegate: XHBTitleBarCallbackDelegate? = nil
    
    /* private variables */
    
    private let _titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        //label = .zero
        return label
    }()
    
    private lazy var _leftButton: XHBButton = {
        let button = XHBButton()
        button.buttonAppearance = _style.buttonApperance
        button.id = .Left
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _rightButton: XHBButton = {
        let button = XHBButton()
        button.buttonAppearance = _style.buttonApperance
        button.iconPosition = .Right
        button.id = .Right
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _rightButton2: XHBButton = {
        let button = XHBButton()
        button.buttonAppearance = _style.buttonApperance
        button.id = .Right2
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()

    private lazy var _iconView: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        return imageView
    }()
    
    private var _contentView: UIView? = nil
    
    private let _style: XHBAppTitleBarStyle
    

    public init(style: XHBAppTitleBarStyle = XHBAppTitleBarStyle()) {
        _style = style
        super.init(frame: .zero)
        super.viewStyle = style
        translatesAutoresizingMaskIntoConstraints = false
        
        _titleLabel.textAppearance = _style.textAppearance
        addSubview(_titleLabel)
    }
    
    public override func layoutSubviews() {
        var frame = self.bounds
        frame.deflate(width: _style.padding, height: 0)
        if leftButton != nil {
            let btnRect = frame.cutLeft(_leftButton.bounds.width)
            _leftButton.frame = btnRect.leftCenterPart(ofSize: _leftButton.bounds.size)
        }
        if rightButton != nil {
            let btnRect = frame.cutRight(_rightButton.bounds.width)
            _rightButton.frame = btnRect.rightCenterPart(ofSize: _rightButton.bounds.size)
        }
        if rightButton2 != nil {
            let btnRect = frame.cutRight(_style.buttonPadding + _rightButton2.bounds.width)
            _rightButton2.frame = btnRect.rightCenterPart(ofSize: _rightButton2.bounds.size)
        }
        // text & icon
        _titleLabel.sizeToFit()
        let width = (icon == nil ? 0 : _iconView.bounds.width + _style.iconPadding) + _titleLabel.bounds.width
        if rightButton != nil || rightButton2 != nil {
            _ = frame.cutRight(_style.textPadding)
        }
        if leftButton != nil {
            // center text & icon
            let c = self.bounds.centerX
            _ = frame.cutLeft(_style.textPadding)
            if frame.centerX > c {
                _ = frame.cutRight((frame.centerX - c) * 2)
            } else {
                _ = frame.cutLeft((c - frame.centerX) * 2)
            }
            if width < frame.width {
                frame = frame.centerPart(ofSize: CGSize(width: width, height: frame.height))
            }
        }
        if icon != nil {
            let iconRect = frame.cutLeft(_style.iconPadding + _iconView.bounds.width)
            _iconView.frame = iconRect.leftCenterPart(ofSize: _iconView.bounds.size)
        }
        _titleLabel.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        delegate?.titleBarButtonClicked?(titleBar: self, btnId: (sender as! XHBButton).id)
    }

    private var _sizeConstrains: (NSLayoutConstraint, NSLayoutConstraint)?
    
    fileprivate func syncSize() {
        var size = CGSize(width: _style.padding * 2, height: _style.height)
        if leftButton != nil {
            size.width += _leftButton.bounds.width
        }
        if icon != nil {
            size.width += _style.iconPadding + _iconView.bounds.width
        }
        if rightButton != nil {
            size.width += _rightButton.bounds.width
        }
        if rightButton2 != nil {
            size.width += _rightButton2.bounds.width + _style.buttonPadding
        }
        size.width += 40 // minimum text width
        if leftButton == nil && (rightButton != nil || rightButton2 != nil) {
            _titleLabel.font = _style.textAppearanceLarge.font
        } else {
            _titleLabel.font = _style.textAppearance.font
        }
        if size.width < bounds.size.width {
            size.width = bounds.size.width
        }
        self.bounds.size = size
        if !translatesAutoresizingMaskIntoConstraints {
            _sizeConstrains = updateSizeConstraint(_sizeConstrains, size, widthRange: 1)
        }
        setNeedsLayout()
    }

    fileprivate func syncContent() {
        if let string = content as? String {
            title = string
        } else if let view = content as? UIView {
            if _contentView != nil {
                _contentView?.removeFromSuperview()
            }
            _contentView = view
            addSubview(view)
        } else if let map = content as? NSDictionary {
            if let btn = map["leftButton"] {
                leftButton = btn
            }
            if let url = map["icon"] as? URL {
                icon = url
            }
            if let btn = map["rightButton"] {
                rightButton = btn
            }
            if let btn = map["rightButton2"] {
                rightButton2 = btn
            }
            if let string = map["title"] as? String {
                title = string
            }
        }
    }

}
