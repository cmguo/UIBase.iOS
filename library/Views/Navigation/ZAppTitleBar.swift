//
//  XHBAppTitleBar.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation


@objc public protocol XHBTitleBarCallbackDelegate : XHBTipViewDelegate {
    @objc optional func titleBarButtonClicked(_ titleBar: XHBAppTitleBar, index: Int)
}


public class XHBAppTitleBar : UIView
{
    
    private static let paddingX: CGFloat = 16
    private static let paddingY: CGFloat = 12
    private static let iconSize: CGFloat = 16
    private static let iconPadding: CGFloat = 8
    private static let defaultFrameColor = UIColor(rgb: 0x1D2126)
    private static let defaultTextColor = UIColor.bluegrey_00
    private static let defaultFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    private static let defaultLargeFont = UIFont.systemFont(ofSize: 14, weight: .regular)

    public var leftButton: Any? {
        didSet {
            _leftButton.content = leftButton
            syncSize()
        }
    }
    
    public var rightButton: Any? {
        didSet {
            _rightButton.content = rightButton
            syncSize()
        }
    }
    
    public var rightButton2: Any? {
        didSet {
            _rightButton2.content = rightButton2
            syncSize()
        }
    }
    
    public var icon: URL? {
        didSet {
            iconView.setIcon(svgURL: icon) {_ in }
            syncSize()
        }
    }
    
    public var title: String = "" {
        didSet {
            messageLabel.text = title
            syncSize()
        }
    }
    
    public var content: Any? = nil {
        didSet {
            
        }
    }
    
    public var delegate: XHBTipViewDelegate? = nil
    
    /* private variables */
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label = .zero
        return label
    }()
    
    private lazy var _leftButton: XHBButton = {
        let button = XHBButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _rightButton: XHBButton = {
        let button = XHBButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _rightButton2: XHBButton = {
        let button = XHBButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.width2 = Self.iconSize
        imageView.bounds.height2 = Self.iconSize
        addSubview(imageView)
        return imageView
    }()
    

    public init() {
        super.init(frame: CGRect.zero)

        messageLabel.font = Self.defaultFont
        messageLabel.textColor = Self.defaultTextColor
        addSubview(messageLabel)
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        (delegate as? XHBTitleBarCallbackDelegate)?.titleBarButtonClicked?(
            self, index: sender == _leftButton ? 0 : 1)
    }

    public override func layoutSubviews() {
        var frame = self.bounds
        frame.deflate(width: Self.paddingX, height: Self.paddingY)
        if leftButton != nil {
            let iconRect = frame.cutLeft(Self.paddingX + _leftButton.bounds.width)
            _leftButton.frame = iconRect.leftCenterPart(ofSize: _leftButton.bounds.size)
        }
        if rightButton != nil {
            let iconRect = frame.cutRight(Self.paddingX + _rightButton.bounds.width)
            _rightButton.frame = iconRect.rightCenterPart(ofSize: _rightButton.bounds.size)
        }
        if rightButton2 != nil {
            let iconRect = frame.cutRight(Self.paddingX + _rightButton2.bounds.width)
            _rightButton2.frame = iconRect.rightCenterPart(ofSize: _rightButton2.bounds.size)
        }
        if icon != nil {
            let iconRect = frame.cutLeft(Self.iconPadding + Self.iconSize)
            iconView.frame = iconRect.leftCenterPart(ofSize: iconView.bounds.size)
        }
        messageLabel.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _sizeConstrains: (NSLayoutConstraint, NSLayoutConstraint)?
    
    fileprivate func syncSize() {
        let mWidth: CGFloat = 0
        var size = CGSize(width: Self.paddingX * 2, height: Self.paddingY * 2)
        if leftButton != nil {
            size.width += Self.paddingX + Self.iconSize
        }
        if icon != nil {
            size.width += Self.iconPadding + Self.iconSize
        }
        if rightButton != nil {
            size.width += Self.paddingX + Self.iconSize
        }
        let textSize = messageLabel.sizeThatFits(CGSize(width: mWidth - size.width, height: 0))
        size.width += textSize.width
        size.height += textSize.height
        _sizeConstrains = updateSizeConstraint(_sizeConstrains, size)
    }
    
}
