//
//  ZDialog.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/27.
//

import Foundation

@objc public protocol ZDialogDelegate {
    @objc optional func dialogButtonClicked(dialog: ZDialog, btnId: ZButton.ButtonId?)
    @objc optional func dialogMoreButtonClicked(dialog: ZDialog, index: Int)
    @objc optional func dialogDismissed(dialog: ZDialog)
}


public class ZDialog : UIView {
    
    public var image: URL? {
        didSet {
            _imageView.setImage(withURL: image)
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
    
    public var content: Any? = nil {
        didSet {
            syncContent()
        }
    }
    
    public var cancelButton: Any? {
        didSet {
            if (cancelButton == nil) {
                if oldValue != nil {
                    _cancelButton.isHidden = true
                }
            } else {
                _cancelButton.content = cancelButton
                _cancelButton.isHidden = false
            }
            setNeedsLayout()
        }
    }
    
    public var confirmButton: Any? {
        didSet {
            if (confirmButton == nil) {
                if oldValue != nil {
                    _confirmButton.isHidden = true
                }
            } else {
                _confirmButton.content = confirmButton
                _confirmButton.isHidden = false
            }
            setNeedsLayout()
        }
    }
    
    public var moreButtons: [Any] = [] {
        didSet {
            syncButtons()
            syncSize()
        }
    }
    
    public var checkBoxText: String? {
        get { return _checkBox.currentTitle }
        set {
            _checkBox.setTitle(newValue)
            _checkBox.isHidden = newValue == nil || newValue!.isEmpty
            syncSize()
        }
    }
    
    public var closeIconColor: UIColor = .clear {
        didSet {
            _closeIcon.setIconColor(color: closeIconColor)
            _closeIcon.isHidden = closeIconColor.cgColor.alpha == 0
        }
    }
    
    public var callback: ZDialogDelegate? = nil
    
    private let _imageView = UIImageView()
    private let _closeIcon = UIImageView()
    private let _label = UILabel()
    private let _label2 = UILabel()
    private var _contentView: UIView? = nil
    private let _cancelButton = ZButton().buttonType(.Tertiary).buttonSize(.Middle)
    private let _confirmButton = ZButton().buttonSize(.Middle)
    private var _moreButtons: [ZButton] = []
    private var _checkBox = ZCheckBox()

    private let _style: ZDialogStyle
    
    public init(style: ZDialogStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = _style.borderRadius
        clipsToBounds = true
        
        _imageView.contentMode = .scaleAspectFit
        addSubview(_imageView)
        _closeIcon.isHidden = true
        _closeIcon.setImage(withURL: .icon_close) {
        }
        _closeIcon.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeIconClicked(_:)))
        _closeIcon.addGestureRecognizer(singleTap)
        addSubview(_closeIcon)
        
        _label.numberOfLines = 1
        _label.textAppearance = style.textAppearance
        _label2.numberOfLines = 0
        _label2.textAlignment = .center
        _label2.textAppearance = style.textAppearance2
        addSubview(_label)
        addSubview(_label2)

        _cancelButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        _confirmButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(_cancelButton)
        addSubview(_confirmButton)
        
        _checkBox.isHidden = true
        addSubview(_checkBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func popUp(target: UIView) {
        ZMaskDialog(content: self, gravity: Gravity.CENTER).show(window: target.window!)
    }
    
    public func dismiss() {
        ZMaskDialog.dismiss(content: self)
    }
    
    public override func didMoveToWindow() {
        if window == nil  {
            callback?.dialogDismissed?(dialog: self)
        }
    }
    
    public override func layoutSubviews() {
        var frame = bounds
        let icsize = CGSize(width: 20, height: 20)
        _closeIcon.frame = frame.rightTopPart(ofSize: CGSize(width: _style.closePadding, height: _style.closePadding))
            .leftBottomPart(ofSize: icsize)
            .offsetBy(dx: -icsize.width, dy: icsize.height)
        if image != nil {
            let isize = _imageView.sizeThatFits(CGSize(width: _style.width, height: .greatestFiniteMagnitude))
            _imageView.frame = frame.cutTop(isize.height)
        } else {
            _ = frame.cutTop(_style.imagePadding)
        }
        _ = frame.cutLeft(_style.paddingX)
        _ = frame.cutRight(_style.paddingX)
        if title != nil {
            _label.frame = frame.cutTop(_style.titlePadding  + _label.bounds.height).bottomCenterPart(ofSize: _label.bounds.size)
        }
        if subTitle != nil {
            let tsize = _label2.sizeThatFits(CGSize(width: _style.width - _style.paddingX * 2, height: .greatestFiniteMagnitude))
            _label2.frame = frame.cutTop((image == nil ? _style.subTitlePadding : _style.subTitlePadding2)  + tsize.height).bottomCenterPart(ofSize: tsize)
        }
        // cut from botton
        _ = frame.cutBottom(_style.bottomPadding)
        if checkBoxText != nil {
            _checkBox.sizeToFit()
            _checkBox.frame = frame.cutBottom(_style.checkBoxPadding + _checkBox.bounds.height).bottomCenterPart(ofSize: _checkBox.bounds.size)
        }
        var buttonsFrame = frame.cutBottom(_style.moreButtonApperance.sizeStyle.height * CGFloat(moreButtons.count))
        for b in _moreButtons {
            b.frame = buttonsFrame.cutTop(_style.moreButtonApperance.sizeStyle.height)
        }
        buttonsFrame = frame.cutBottom(_cancelButton.bounds.height)
        if cancelButton != nil {
            _cancelButton.frame = buttonsFrame.cutLeft(_style.buttonWidth)
            _confirmButton.frame = buttonsFrame.cutRight(_style.buttonWidth)
        } else {
            _confirmButton.frame = buttonsFrame
        }
        _ = frame.cutBottom(image == nil ? _style.buttonPadding : _style.buttonPadding2)
        if let c = _contentView {
            c.frame = frame
        }
    }
    
    /* private */
    
    fileprivate func syncContent() {
        if let view = content as? UIView {
            if view == _contentView {
                return
            }
            if _contentView != nil {
                _contentView?.removeFromSuperview()
                _contentView?.translatesAutoresizingMaskIntoConstraints = false
            }
            view.translatesAutoresizingMaskIntoConstraints = true
            _contentView = view
            addSubview(view)
            syncSize()
        } else if (_contentView != nil) {
            _contentView?.removeFromSuperview()
            _contentView?.translatesAutoresizingMaskIntoConstraints = false
            _contentView = nil
            syncSize()
        }
    }
    
    private func syncButtons() {
        while _moreButtons.count < moreButtons.count {
            let button = ZButton()
                .buttonAppearance(_style.moreButtonApperance)
            button.addTarget(self, action: #selector(moreButtonClicked(_:)), for: .touchUpInside)
            addSubview(button)
            _moreButtons.append(button)
        }
        while moreButtons.count < _moreButtons.count {
            let button = _moreButtons.removeLast()
            button.removeFromSuperview()
        }
        for i in 0..<moreButtons.count {
            let button = _moreButtons[i]
            button.content = moreButtons[i]
        }
    }
    
    @objc private func buttonClicked(_ sender: UIView) {
        callback?.dialogButtonClicked?(dialog: self, btnId: (sender as! ZButton).id)
    }
    
    @objc private func moreButtonClicked(_ sender: UIView) {
        callback?.dialogMoreButtonClicked?(dialog: self, index: _moreButtons.firstIndex(of: sender as! ZButton) ?? -1)
    }
    
    @objc private func closeIconClicked(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == .recognized {
            dismiss()
        }
    }
    
    private var _sizeConstrains: (NSLayoutConstraint, NSLayoutConstraint)?
    
    fileprivate func syncSize() {
        var size = CGSize(width: _style.width, height: 0)
        if image != nil {
            let isize = _imageView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
            size.height += isize.height
        } else {
            size.height += _style.imagePadding
        }
        if title != nil {
            _label.sizeToFit()
            size.height += _style.titlePadding  + _label.bounds.height
        }
        if subTitle != nil {
            let tsize = _label2.sizeThatFits(CGSize(width: _style.width - _style.paddingX * 2, height: .greatestFiniteMagnitude))
            size.height += (image == nil ? _style.subTitlePadding : _style.subTitlePadding2) + tsize.height
        }
        var heightRange = 0
        if let c = _contentView {
            let ch = c.heightConstraint()
            heightRange = ch.0
            size.height += ch.1
        }
        size.height += (_contentView == nil ? _style.buttonPadding : _style.buttonPadding2) +
            _cancelButton.bounds.height
        size.height += _style.moreButtonApperance.sizeStyle.height * CGFloat(moreButtons.count)
        if checkBoxText != nil {
            size.height += _style.checkBoxPadding + _checkBox.bounds.height
        }
        size.height += _style.bottomPadding
        _sizeConstrains = updateSizeConstraint(_sizeConstrains, size, widthRange: 0, heightRange: heightRange)
        setNeedsLayout()
    }

}
