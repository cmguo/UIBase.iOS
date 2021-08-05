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
    private let _tableView = UITableView()
    
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
        addSubview(_label2)
        _spplitter.backgroundColor = .bluegrey_100
        addSubview(_spplitter)
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActionSheet");
        _tableView.separatorInset = .zero
        _tableView.separatorColor = .bluegrey_100
        _tableView.dataSource = self
        _tableView.delegate = self
        addSubview(_tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        var frame = bounds
        if icon != nil || title != nil || subTitle != nil {
            _ = frame.cutTop(_style.paddingY)
        }
        if icon != nil {
            _imageView.frame = frame.cutTop(_style.iconPadding + _style.iconSize)
                .bottomCenterPart(ofSize: CGSize(width: _style.iconSize, height: _style.iconSize))
            _ = frame.cutTop(_style.iconPadding)
        }
        if title != nil {
            _label.frame = frame.cutTop(_label.bounds.height)
                .bottomCenterPart(ofSize: _label.bounds.size)
        }
        if subTitle != nil {
            let tsize = _label2.sizeThatFits(CGSize(width: 300.0, height: .greatestFiniteMagnitude))
            _label2.frame = frame.cutTop(tsize.height)
                .bottomCenterPart(ofSize: tsize)
        }
        if frame.top > bounds.top && frame.height < bounds.height {
            _ = frame.cutTop(_style.paddingY)
            _spplitter.frame = frame.cutTop(1)
        } else {
            _spplitter.frame = .zero
        }
        _tableView.frame = frame
        _tableView.isScrollEnabled = frame.height < _style.buttonApperance.height! * CGFloat(buttons.count)
    }
    
    private var _constraint: (NSLayoutConstraint, NSLayoutConstraint)? = nil

    private func syncSize() {
        var size = CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        if icon != nil {
            size.height += _style.iconPadding * 2 + _style.iconSize
        }
        if title != nil {
            _label.sizeToFit()
            size.height += _label.bounds.height
        }
        if subTitle != nil {
            let tsize = _label2.sizeThatFits(CGSize(width: 300.0, height: .greatestFiniteMagnitude))
            size.height += tsize.height
        }
        if size.height > 0 && buttons.count > 0 {
            size.height += _style.paddingY * 2 + 1 // spplitter
        }
        size.height += _style.buttonApperance.height! * CGFloat(buttons.count)
        _constraint = updateSizeConstraint(_constraint, size, widthRange: -1, heightRange: -1)
    }
    
    private func syncButtons() {
        _tableView.reloadData()
    }
    
    @objc fileprivate func buttonClicked(_ sender: UIView) {
        guard let cell = sender.superview(ofType: UITableViewCell.self) else { return }
        guard let index = _tableView.indexPath(for: cell) else { return }
        delegate?.actionSheet?(self, onAction: index.row)
    }

}

extension ZActionSheet : UITableViewDataSource {
    
    private func createButton(_ cell: UITableViewCell) -> ZButton {
        let button = ZButton()
            .buttonAppearance(_style.buttonApperance)
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.contentView.addSubview(button)
        return button
    }
    
    private func bindButton(_ button: ZButton, _ content: Any, _ state : UIControl.State?) {
        let enabled = !(state?.contains(.disabled) ?? false)
        let selected = state?.contains(.selected) ?? false
        button.content = content
        button.isEnabled = enabled
        button.isSelected = selected
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionSheet")
            ?? UITableViewCell(style: .default, reuseIdentifier: "ActionSheet")
        let button = cell.subview(ofType: ZButton.self) ?? createButton(cell)
        let i = indexPath.row
        bindButton(button, buttons[i], i < (states?.count ?? 0) ? states?[i] : nil)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _style.buttonApperance.height!
    }
}

extension ZActionSheet : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let button = cell.subview(ofType: ZButton.self) else {
            return
        }
        button.frame = cell.bounds
    }
}
