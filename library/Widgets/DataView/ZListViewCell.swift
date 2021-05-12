//
//  ZListViewCell.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation

class ZListViewCell : UITableViewCell {
    
    private static let DefaultStyle = ZListItemStyle()

    private lazy var _leftCheckBox: ZCheckBox = {
        let cb = ZCheckBox()
        addSubview(cb)
        return cb
    }()
    
    private lazy var _iconView: UIImageView = {
        let iv = UIImageView()
        addSubview(iv)
        return iv
    }()
    
    private lazy var _subTextLabel: UILabel = {
        let tl = UILabel()
        tl.textAppearance = _style.subTextAppearance
        addSubview(tl)
        return tl
    }()
    
    var _viewState: Int = 0
    var _rightView: UIView? = nil
    var _rightViewType: ZListItemContentType? = nil
    
    private var _style: ZListItemStyle = ZListViewCell.DefaultStyle
    private var _heightConstraint: NSLayoutConstraint? = nil
    
    // only once before bindData
    public func setStyle(_ style: ZListItemStyle) {
        _style = style
        backgroundColor = style.backgroundColor
        selectionStyle = .none
        textLabel?.textAppearance = _style.textAppearance
    }
    
    public func bindData(_ data: ZListItemProtocol, listView: ZListView) {
        let oldState = _viewState
        _viewState = 0
        textLabel?.text = data.title
        var height = _style.height
        var iconSize = _style.iconSize
        if let subTitle = data.subTitle {
            height = _style.height2
            iconSize = _style.iconSize2
            _subTextLabel.text = subTitle
            _viewState = 1
        } else if (oldState & 1) != 0 {
            _subTextLabel.text = nil
        }
        bounds.height2 = height
        _heightConstraint = updateHeightConstraint(_heightConstraint, height, range: 1)
        if let icon = data.icon {
            _iconView.bounds.size = CGSize(width: iconSize, height: iconSize)
            _iconView.setImage(wild: icon)
            _viewState |= 2
        }
        _rightView = listView.switchRightView(data.contentType, _rightView, _rightViewType)
        _rightViewType = data.contentType
        if let r = _rightView {
            listView.bindRightView(_rightViewType!, r, data.content)
            addSubview(r)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = bounds
        frame.deflate(width: _style.paddingX, height: 0)
        var iconPadding = _style.iconPadding
        var iconSize = _style.iconSize
        if (_viewState & 1) != 0 {
            iconPadding = _style.iconPadding2
            iconSize = _style.iconSize2
        }
        if (_viewState & 2) != 0 {
            _iconView.frame = frame.cutLeft(iconSize + iconPadding).leftCenterPart(ofSize: _iconView.bounds.size)
        }
        if let r = _rightView {
            r.frame = frame.cutRight(r.bounds.width + iconPadding).rightCenterPart(ofSize: r.bounds.size)
        }
        textLabel?.sizeToFit()
        if (_viewState & 1) != 0 {
            _subTextLabel.sizeToFit()
            let h = textLabel!.bounds.height + _subTextLabel.bounds.height + _style.subTextPadding
            frame = frame.centerPart(ofSize: CGSize(width: frame.width, height: h))
            textLabel?.frame = frame.cutTop(textLabel!.bounds.height)
            _subTextLabel.frame = frame
        } else {
            textLabel?.frame = frame.centerPart(ofSize: CGSize(width: frame.width, height: textLabel!.bounds.height))
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil, let r = _rightView {
            _rightView = superview(ofType: ZListView.self)?.switchRightView(nil, r, _rightViewType)
            _rightViewType = nil
        }
    }
    
}
