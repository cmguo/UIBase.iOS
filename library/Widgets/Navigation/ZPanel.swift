//
//  ZPanel.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation

@objc public protocol ZPanelDelegate {
    @objc optional func panelButtonClicked(panel: ZPanel, btnId: ZButton.ButtonId?)
    @objc optional func panelDismissed(panel: ZPanel)
}


public class ZPanel : UIView, ZTitleBarDelegate {
    
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
            syncContent()
        }
    }
    
    public var delegate: ZPanelDelegate? = nil

    
    /* private propertis */
    
    private lazy var _titleBar: ZAppTitleBar = {
        let bar = ZAppTitleBar()
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
    
    private lazy var _bottomButton: ZButton = {
        let button = ZButton()
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

    private let _style: ZPanelStyle
    
    public init(style: ZPanelStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.viewStyle = style
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func popUp(target: UIView) {
        ZMaskDialog(content: self).show(window: target.window!)
    }
    
    public func dismiss() {
        ZMaskDialog.dismiss(content: self)
    }
    
    public func titleBarButtonClicked(titleBar: ZAppTitleBar, btnId: ZButton.ButtonId?) {
        delegate?.panelButtonClicked?(panel: self, btnId: btnId)
    }
    
    public override func didMoveToWindow() {
        if window == nil  {
            delegate?.panelDismissed?(panel: self)
        }
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
        if let c = _contentView {
            c.frame = frame
        }
    }

    private var _sizeConstrains: (NSLayoutConstraint, NSLayoutConstraint)?
    
    @objc private func buttonClicked(_ sender: UIView) {
        delegate?.panelButtonClicked?(panel: self, btnId: (sender as! ZButton).id)
    }
    
    fileprivate func syncContent() {
        if let string = content as? String {
            titleBar = string
        } else if let view = content as? UIView {
            if view == _contentView {
                return
            }
            if _contentView != nil {
                _contentView?.removeFromSuperview()
                //_contentView?.translatesAutoresizingMaskIntoConstraints = false
            }
            view.translatesAutoresizingMaskIntoConstraints = true
            _contentView = view
            addSubview(view)
            syncSize()
        } else if (_contentView != nil) {
            _contentView?.removeFromSuperview()
            //_contentView?.translatesAutoresizingMaskIntoConstraints = false
            _contentView = nil
            syncSize()
        }
    }
    
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
        var heightRange = 0
        if let c = _contentView {
            let ch = c.heightConstraint()
            heightRange = ch.0
            size.height += ch.1
        }
        if size.height < 200 {
            size.height = 200
        }
        _sizeConstrains = updateSizeConstraint(_sizeConstrains, size, widthRange: 1, heightRange: heightRange)
        setNeedsLayout()
    }


}
