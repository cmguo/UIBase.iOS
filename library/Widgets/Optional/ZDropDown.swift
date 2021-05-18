//
//  ZDropDown.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

@objc public protocol ZDropDownDelegate {
    @objc optional func dropDownFinished(dropDown: ZDropDown, selection: Int, withValue: Any?)
}

public class ZDropDown : UIView {

    public var titles: [Any] = []
    
    public var icons: [Any?]? = nil
    
    public var shadowRadius: CGFloat = 0 {
        didSet {
            _shadowFrame.layer.shadowRadius = shadowRadius
        }
    }
    
    public var borderRadius: CGFloat = 0 {
        didSet {
            _shadowFrame.layer.cornerRadius = borderRadius
            _tableView.layer.cornerRadius = borderRadius
        }
    }
    
    public var width: CGFloat = 0
    
    public var duration: TimeInterval = 0.3
    
    private let _shadowFrame = UIView()
    private let _tableView = UITableView()
    
    private let _style: ZDropDownStyle
    
    public init(style: ZDropDownStyle = .init()) {
        _style = style
        shadowRadius = _style.shadowRadius
        borderRadius = _style.borderRadius
        super.init(frame: .zero)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.delegate = self
        addGestureRecognizer(tap)

        _shadowFrame.clipsToBounds = false
        _shadowFrame.backgroundColor = .bluegrey_00
        _shadowFrame.layer.shadowColor = UIColor.gray.cgColor
        _shadowFrame.layer.shadowRadius = _style.shadowRadius
        _shadowFrame.layer.shadowOffset = CGSize(width: 0, height: 0)
        _shadowFrame.layer.cornerRadius = _style.borderRadius
        _shadowFrame.layer.shadowOpacity = 0.8
        addSubview(_shadowFrame)

        _tableView.layer.cornerRadius = _style.borderRadius
        _tableView.register(ZDropDownCell.self, forCellReuseIdentifier: "DropDown")
        _tableView.delegate = self
        addSubview(_tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _isDrop = false
    private var _delegate: ZDropDownDelegate? = nil
    
    private var _radioGroup = ZRadioGroup()
    private var _buttons: [Int: [UIView]] = [:]

    public func popAt(_ target: UIView, withDelegate: ZDropDownDelegate? = nil) {
        if(_isDrop) {
            return
        }
        guard let window = target.window else {
            return
        }
        _isDrop = true
        _delegate = withDelegate
        _tableView.dataSource = self
        self.frame = window.bounds
        window.addSubview(self)
        let frame = calcBounds(target)
        _shadowFrame.frame = CGRect(x: frame.left, y: frame.top, width: frame.width, height: 0)
        _tableView.frame = _shadowFrame.frame
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let tableView = self?._tableView, let shadowFrame = self?._shadowFrame else {
                return
            }
            if frame.size.height < 0 {
                shadowFrame.frame.origin.y = frame.bottom
                shadowFrame.frame.size.height = frame.height
                tableView.frame.origin.y = frame.bottom
                tableView.frame.size.height = frame.height
            } else {
                shadowFrame.frame.size.height = frame.height
                tableView.frame.size.height = frame.height
            }
        })
    }
    
    public func dismiss() {
        if(!_isDrop) {
            return
        }
        _isDrop = false
        
        UIView.animate(withDuration: duration / 2, animations: { [weak self] in
            guard let tableView = self?._tableView, let shadowFrame = self?._shadowFrame else {
                return
            }
            tableView.frame.size.height = 0.0
            shadowFrame.frame.size.height = 0.0
        }) { [weak self] _ in
            if let weakSelf = self {
                weakSelf.removeFromSuperview()
            }
        }
    }
    
    /* private func */
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer? = nil) {
        dismiss()
        _delegate?.dropDownFinished?(dropDown: self, selection: -1, withValue: nil)
    }
    
    private func tableSize() -> CGSize {
        _tableView.frame.size = UIScreen.main.bounds.size
        _tableView.layoutSubviews()
        var width = self.width
        if width < 0 {
            width += UIScreen.main.bounds.width
        }
        for i in 0..<titles.count {
            let w = (_tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! ZDropDownCell).width()
            if w > width {
                width = w
            }
        }
        return CGSize(width: width, height: _style.itemHeight * CGFloat(titles.count))
    }
    
    private func calcBounds(_ target: UIView) -> CGRect {
        guard let window = target.window else {
            return .zero
        }
        let tBounds = target.convert(target.bounds, to: nil)
        var dBounds = CGRect(origin: .zero, size: tableSize())
        dBounds.inflate(_style.shadowRadius)
        dBounds.leftTop = tBounds.leftBottom
        if( dBounds.height > _style.maxHeight) {
            _tableView.isScrollEnabled = true
            dBounds.height2 = _style.maxHeight
        } else {
            _tableView.isScrollEnabled = false
        }
        if dBounds.bottom > window.bounds.bottom {
            dBounds.top = tBounds.top
            dBounds.height2 = -dBounds.height
        }
        if dBounds.right > window.bounds.right {
            dBounds.right = window.bounds.right
        }
        if dBounds.size.height < 0 {
            dBounds.deflate(width: _style.shadowRadius, height: -_style.shadowRadius)
        } else {
            dBounds.deflate(_style.shadowRadius)
        }
        return dBounds
    }
}

extension ZDropDown : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDown") as! ZDropDownCell
        let row = indexPath.row
        cell.setStyle(_style)
        cell.setContent(titles[row], icon: row < (icons?.count ?? 0) ? icons?[row] : nil, dropDown: self)
        if (row == titles.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _style.itemHeight
    }
    
}

extension ZDropDown : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
        let cell = tableView.cellForRow(at: indexPath) as! ZDropDownCell
        var value: Any? = nil
        if cell._buttonType > 0 {
            value = tapButton(cell._buttonType, cell._button!)
        }
        _delegate?.dropDownFinished?(dropDown: self, selection: indexPath.row, withValue: value)
    }
    
}

extension ZDropDown : UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
    
}

extension ZDropDown {
    
    func getButton(_ type: Int, _ oldType: Int, _ oldButton: UIView?) -> UIView? {
        if (oldType == 2) {
            _radioGroup.removeRadioButton(oldButton as! ZRadioButton)
        }
        if let old = oldButton {
            old.removeFromSuperview()
            var btns = _buttons[oldType] ?? []
            btns.append(old)
            _buttons[oldType] = btns
        }
        if type == 0 {
            return nil
        }
        if let btns = _buttons[type], !btns.isEmpty {
            var btns2 = btns
            let btn = btns2.remove(at: 0)
            _buttons[type] = btns2
            if type == 2 {
                _radioGroup.addRadioButton(btn as! ZRadioButton)
            }
            return btn
        }
        if type == 1 {
            let cb = ZCheckBox()
            cb.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
            return cb
        } else if type == 2 {
            let rd = ZRadioButton()
            rd.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
            _radioGroup.addRadioButton(rd)
            return rd
        } else {
            return nil
        }
    }

    private func tapButton(_ type: Int, _ button: UIView) -> Any? {
        switch type {
        case 1:
            if let cb = button as? ZCheckBox {
                cb.toggle()
                return cb.checkedState
            }
        case 2:
            if let rd = button as? ZRadioButton {
                rd.toggle()
                return rd.checked
            }
        default:
            break
        }
        return nil
    }
    
    @objc private func valueChanged(_ sender: UIView) {
        if (!_isDrop) { return }
        guard let cell = sender.superview(ofType: ZDropDownCell.self) else { return }
        guard let index =  _tableView.indexPath(for: cell) else { return }
        dismiss()
        var value: Any? = nil
        switch cell._buttonType {
        case 1:
            if let cb = cell._button as? ZCheckBox {
                value = cb.checkedState
            }
        case 2:
            if let rd = cell._button as? ZRadioButton {
                value = rd.checked
            }
        default:
            break
        }
        _delegate?.dropDownFinished?(dropDown: self, selection: index.row, withValue: value)
    }
    
}

class ZDropDownCell : UITableViewCell {
    
    private var _style: ZDropDownStyle? = nil
    
    private let _imageView = UIImageView()
    var _button: UIView? = nil
    var _buttonType: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        _imageView.contentMode = .scaleAspectFit
        contentView.addSubview(_imageView)
        textLabel?.numberOfLines = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle(_ style: ZDropDownStyle) {
        if _style != nil {
            return
        }
        _style = style
        _imageView.bounds.size = CGSize(width: _style!.iconSize, height: _style!.iconSize)
        textLabel?.font = _style?.textAppearance.font
        textLabel?.textColor = _style?.textAppearance.textColor
    }
    
    func setContent(_ title: Any, icon: Any?, dropDown: ZDropDown) {
        var title = "\(title)"
        var buttonType = 0
        if (title.hasSuffix("(x)")) {
            buttonType = 1
            title = title[0..<title.count - 3]
        } else if (title.hasSuffix("(*)")) {
            buttonType = 2
            title = title[0..<title.count - 3]
        }
        if buttonType != _buttonType {
            _button = dropDown.getButton(buttonType, _buttonType, _button)
            _buttonType = buttonType
            if let b = _button {
                addSubview(b)
            }
        }
        textLabel?.text = title
        if let url = icon as? URL {
            _imageView.setImage(withURL: url)
            _imageView.isHidden = false
        } else {
            _imageView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var bounds = contentView.bounds
        bounds.deflate(width: _style!.itemPaddingX, height: _style!.itemPaddingY)
        if !_imageView.isHidden {
            _imageView.frame = bounds.cutLeft(_style!.iconSize + _style!.iconPadding).leftCenterPart(ofSize: _imageView.bounds.size)
        }
        if let b = _button {
            b.frame = bounds.cutRight(_style!.iconPadding + b.bounds.width).rightCenterPart(ofSize: b.bounds.size)
        }
        textLabel?.frame = bounds
    }
    
    func width() -> CGFloat {
        var w = _style!.itemPaddingX * 2
        w += textLabel!.text!.boundingSize(font: textLabel!.font).width
        if !_imageView.isHidden {
            w += _style!.iconSize + _style!.iconPadding
        }
        if let b = _button {
            w += _style!.iconPadding + b.bounds.width
        }
        return w
    }
}
