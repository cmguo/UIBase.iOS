//
//  ZPickerView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation

@objc public protocol ZPickerViewDelegate {
    @objc optional func onSelectionChanged(picker: ZPickerView, selection: Int)
    @objc optional func onSelectionsChanged(picker: ZPickerView, selections: [Int])
}

public class ZPickerView : UIView, UITableViewDataSource, UITableViewDelegate {
    
    public var titles: [Any] = [] {
        didSet {
            _tableView.reloadData()
            updateSize()
        }
    }
    
    public var icons: [Any?]? = nil {
        didSet {
            _tableView.reloadData()
        }
    }
    
    public var states: [UIControl.State?]? = nil {
        didSet {
            _tableView.reloadData()
        }
    }
    
    public var singleSelection = false {
        didSet {
            _tableView.reloadData()
            _selectImage.isHidden = !(singleSelection && selection != nil)
            layoutSelectImage()
        }
    }
    
    public var selections: [Int] = [] {
        didSet {
            _tableView.reloadData()
            _selectImage.isHidden = !(singleSelection && selection != nil)
        }
    }

    public var selection: Int? {
        get { selections.count == 1 ? selections.first : nil }
        set {
            selections = (newValue == nil) ? [] as [Int] : [newValue!]
        }
    }
    
    public var delegate: ZPickerViewDelegate? = nil

    private let _tableView = UITableView()
    private let _selectImage = UIImageView()

    private let _style: ZPickerViewStyle

    public init(style: ZPickerViewStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        
        _tableView.register(ZPickerCell.self, forCellReuseIdentifier: "Picker")
        _tableView.delegate = self
        _tableView.dataSource = self
        addSubview(_tableView)
    
        _selectImage.setImage(withURL: .icon_left)
        _selectImage.isHidden = true
        addSubview(_selectImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picker") as! ZPickerCell
        let row = indexPath.row
        let checkedState: ZCheckBox.CheckedState = singleSelection ? .HalfChecked : (selections.contains(row) ? .FullChecked : .NotChecked)
        cell.setStyle(self, _style)
        cell.setContent(titles[row], icon: row < (icons?.count ?? 0) ? icons?[row] : nil, state: row < (states?.count ?? 0) ? states?[row] : nil, checkedState: checkedState)
        if (row == titles.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _style.itemHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if singleSelection {
            select(indexPath.row, true)
        } else {
            (_tableView.cellForRow(at: indexPath) as! ZPickerCell)._checkBox.toggle()
        }
    }
    
    public override func layoutSubviews() {
        superview?.layoutSubviews()
        _tableView.frame = bounds
        layoutSelectImage()
    }
    
    private func select(_ index: Int, _ selected: Bool) {
        let old = selection
        if singleSelection {
            selections.removeAll()
            selections.append(index)
            _selectImage.isHidden = false
            layoutSelectImage()
        } else if selected {
            selections.insert(index, at: selections.firstIndex(where: { i in i > index }) ?? selections.count)
        } else {
            selections.removeAll(where: { i in i == index })
        }
        delegate?.onSelectionsChanged?(picker: self, selections: selections)
        if old != selection {
            delegate?.onSelectionChanged?(picker: self, selection: selection ?? -1)
        }
    }
    
    @objc fileprivate func checkBoxValueChanged(_ sender: UIView) {
        let cell = sender.superview?.superview as! ZPickerCell
        let path = _tableView.indexPath(for: cell)
        if let path = path {
            select(path.row, (sender as! ZCheckBox).checkedState == .FullChecked)
        }
    }
    
    private func layoutSelectImage() {
        guard singleSelection, let s = selection else {
            return
        }
        let cb = (_tableView.cellForRow(at: IndexPath(item: s, section: 0)) as? ZPickerCell)?._checkBox
        if let cb = cb {
            _selectImage.frame = cb.convert(cb.bounds, to: self)
        } else {
            _selectImage.frame = .zero
        }
    }
    
    private func tableSize() -> CGSize {
        _tableView.frame.size = UIScreen.main.bounds.size
        _tableView.layoutSubviews() // TODO: 
        var width: CGFloat = 0
        for i in 0..<titles.count {
            let w = (_tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! ZPickerCell).width()
            if w > width {
                width = w
            }
        }
        return CGSize(width: width, height: _style.itemHeight * CGFloat(titles.count))
    }
    
    private var sizeContraint: (NSLayoutConstraint, NSLayoutConstraint)? = nil
    
    private func updateSize() {
        let size = tableSize()
        sizeContraint = updateSizeConstraint(sizeContraint, size, widthRange: 1, heightRange:  -1)
    }
}


class ZPickerCell : UITableViewCell {
    
    private var _style: ZPickerViewStyle? = nil
    
    private let _imageView = UIImageView()
    fileprivate let _checkBox = ZCheckBox()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        _imageView.contentMode = .scaleAspectFit
        contentView.addSubview(_imageView)
        contentView.addSubview(_checkBox)
        textLabel?.numberOfLines = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle(_ picker: ZPickerView, _ style: ZPickerViewStyle) {
        if _style != nil {
            return
        }
        backgroundColor = style.backgroundColor
        _checkBox.addTarget(picker, action: #selector(ZPickerView.checkBoxValueChanged(_:)), for: .valueChanged)
        _style = style
        _imageView.bounds.size = CGSize(width: _style!.iconSize, height: _style!.iconSize)
        textLabel?.font = _style?.textAppearance.font
        textLabel?.textColor = _style?.textAppearance.textColor
    }
    
    func setContent(_ title: Any, icon: Any?, state: UIControl.State?, checkedState: ZCheckBox.CheckedState) {
        textLabel?.text = "\(title)"
        if let url = icon as? URL {
            _imageView.setImage(withURL: url)
            _imageView.isHidden = false
        } else {
            _imageView.isHidden = true
        }
        _checkBox.isHidden = checkedState == .HalfChecked
        _checkBox.checkedState = checkedState
        let enabled = !(state?.contains(.disabled) ?? false)
        _checkBox.isEnabled = enabled
        textLabel?.isEnabled = enabled
        isUserInteractionEnabled = enabled
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var bounds = contentView.bounds
        bounds.deflate(width: _style!.itemPaddingX, height: _style!.itemPaddingY)
        if !_imageView.isHidden {
            _imageView.frame = bounds.cutLeft(_style!.iconSize + _style!.iconPadding).leftCenterPart(ofSize: _imageView.bounds.size)
        }
        if !_checkBox.isHidden {
            _checkBox.frame = bounds.cutRight(_checkBox.bounds.width + _style!.iconPadding).rightCenterPart(ofSize: _checkBox.bounds.size)
        }
        textLabel?.frame = bounds
    }
    
    func width() -> CGFloat {
        var w = _style!.itemPaddingX * 2
        w += textLabel!.text!.boundingSize(font: textLabel!.font).width
        if !_imageView.isHidden {
            w += _style!.iconSize + _style!.iconPadding
        }
        if !_checkBox.isHidden {
            w += _checkBox.bounds.width + _style!.iconPadding
        }
        return w
    }
}
