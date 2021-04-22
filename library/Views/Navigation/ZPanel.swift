//
//  XHBPanel.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

@objc public protocol XHBPanelCallbackDelegate {
    @objc optional func panelButtonClicked(_ panel: XHBPanel, _ btnId: XHBButton.ButtonId?)
}


public class XHBPanel : UIView, XHBTitleBarCallbackDelegate {
    
    public var titleBar: Any? {
        didSet {
            if (titleBar == nil) {
                if oldValue != nil {
                    _titleBar.isHidden = true
                    _titleSplitter.isHidden = true
                }
            } else {
                _titleBar.content = titleBar
                _titleBar.isHidden = false
                _titleSplitter.isHidden = false
            }
            syncSize()
        }
    }
    
    public var bottomButton: Any? {
        didSet {
            if (bottomButton == nil) {
                if oldValue != nil {
                    _bottomButton.isHidden = true
                    _bottomSplitter.isHidden = true
                }
            } else {
                _bottomButton.content = bottomButton
                _bottomButton.isHidden = false
                _bottomSplitter.isHidden = false
            }
            syncSize()
        }
    }
    
    public var content: Any? = nil {
        didSet {
            if let string = content as? String {
                titleBar = string
            } else if let view = content as? UIView {
                if _contentView != nil {
                    _contentView?.removeFromSuperview()
                }
                _contentView = view
                addSubview(view)
            }
        }
    }
    
    public var delegate: XHBPanelCallbackDelegate? = nil

    
    /* private propertis */
    
    private lazy var _titleBar: XHBAppTitleBar = {
        let bar = XHBAppTitleBar()
        bar.translatesAutoresizingMaskIntoConstraints = true
        bar.textAppearance = TextAppearance.Head3
        bar.delegate = self
        addSubview(bar)
        return bar
    }()
    
    private lazy var _titleSplitter: UIView = {
        let view = UIView()
        view.backgroundColor = .bluegrey_100
        addSubview(view)
        return view
    }()
    
    private lazy var _bottomButton: XHBButton = {
        let button = XHBButton()
        button.buttonAppearance = _style.buttonApperance
        button.id = .Bottom
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _bottomSplitter: UIView = {
        let view = UIView()
        view.backgroundColor = .bluegrey_50
        addSubview(view)
        return view
    }()
    
    private var _contentView: UIView? = nil

    private let _style: XHBPanelStyle
    
    public init(style: XHBPanelStyle = XHBPanelStyle()) {
        _style = style
        super.init(frame: .zero)
        super.viewStyle = style
        translatesAutoresizingMaskIntoConstraints = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        delegate?.panelButtonClicked?(self, (sender as! XHBButton).id)
    }
    
    public func titleBarButtonClicked(_ titleBar: XHBAppTitleBar, _ btnId: XHBButton.ButtonId?) {
        delegate?.panelButtonClicked?(self, btnId)
    }
    
    public override func layoutSubviews() {
        var frame = self.bounds
        let path = UIBezierPath(roundedRect: frame, byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: _style.borderRadius, height: _style.borderRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        if titleBar != nil {
            _titleBar.frame = frame.cutTop(_titleBar.bounds.height)
            _titleSplitter.frame = frame.cutTop(1)
        }
        if bottomButton != nil {
            _bottomButton.frame = frame.cutBottom(_style.bottomHeight)
            _bottomSplitter.frame = frame.cutBottom(10)
        }
        _contentView?.frame = frame
    }

    private var _sizeConstrains: (NSLayoutConstraint, NSLayoutConstraint)?
    
    fileprivate func syncSize() {
        var size = CGSize(width: 100, height: 0)
        if titleBar != nil {
            size.width = _titleBar.bounds.width
            size.height += _titleBar.bounds.height + 1
        }
        if bottomButton != nil {
            if _bottomButton.bounds.width > size.width {
                size.width = _bottomButton.bounds.width
            }
            size.height += 10 + _style.bottomHeight
        }
        if let c = _contentView {
            size.height += c.bounds.height
        }
        if size.height < 200 {
            size.height = 200
        }
        _sizeConstrains = updateSizeConstraint(_sizeConstrains, size, widthRange: 1, heightRange: 1)
        setNeedsLayout()
    }


}
