//
//  ZListView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

public enum ZListItemContentType {
    case Button
    case TextField
    case CheckBox
    case RadioButton
    case SwitchButton
}

public protocol ZListItemProtocol {
    
    var title: String { get }
    var subTitle: String? { get }
    var icon: Any? { get }
    var contentType: ZListItemContentType? { get }
    var content: Any? { get }
    var badge: Any? { get }
}

public protocol ZListSectionProtocol : ZListItemProtocol {
    var items: [ZListItemProtocol] { get }
}

@objc public protocol ZListViewDelegate {
    @objc optional func listView(_ listView: ZListView, itemAt: IndexPath, changedTo: Any?)
}

public class ZListView : UITableView {
    
    public var data: [ZListItemProtocol] = [] {
        didSet {
            _hasSection = data.contains() { d in d is ZListSectionProtocol }
            self.reloadData()
        }
    }
    
    public var listDelegate: ZListViewDelegate? = nil
    
    private let _style: ZListViewStyle
    
    private var _hasSection = false
    private var _viewCache: [ZListItemContentType: [UIView]] = [:]
    private var _radioGroup = ZRadioGroup()
    
    public init(style: ZListViewStyle = .init()) {
        _style = style
        super.init(frame: .zero, style: .plain)
        super.register(ZListViewCell.self, forCellReuseIdentifier: "ZListView")
        super.dataSource = self
        super.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class ZBaseListItem : ZListItemProtocol {
    public var title: String = ""
    public var subTitle: String? = nil
    public var icon: Any? = nil
    public var contentType: ZListItemContentType? = nil
    public var content: Any? = nil
    public var badge: Any? = nil
}

extension ZListView : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        _hasSection ? data.count : 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !_hasSection { return data.count }
        if let sec = data[section] as? ZListSectionProtocol {
            return sec.items.count
        } else {
            return 1
        }
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAt(indexPath)
        let cell = dequeueReusableCell(withIdentifier: "ZListView") as! ZListViewCell
        cell.setStyle(_style.itemStyle)
        cell.bindData(item, listView: self)
        return cell
    }
    
    private func itemAt(_ indexPath: IndexPath) -> ZListItemProtocol {
        if _hasSection {
            if let sec = data[indexPath.section] as? ZListSectionProtocol {
                return sec.items[indexPath.row]
            } else {
                return data[indexPath.section]
            }
        } else {
            return data[indexPath.row]
        }
    }
}

extension ZListView : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if _hasSection, data[section] is ZListSectionProtocol {
            return _style.headerStyle.height
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard _hasSection, data[section] is ZListSectionProtocol else {
            return nil
        }
        let item = data[section]
        let cell = dequeueReusableCell(withIdentifier: "ZListView") as! ZListViewCell
        cell.setStyle(_style.headerStyle)
        cell.bindData(item, listView: self)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cellForRow(at: indexPath) as! ZListViewCell
        let item = itemAt(indexPath)
        if let type = item.contentType {
            tapRightView(type, cell._rightView!)
        }
    }
    
}

extension ZListView : UITextFieldDelegate {

    func switchRightView(_ type: ZListItemContentType?, _ view: UIView?, _ type2: ZListItemContentType?) -> UIView? {
        if let view = view {
            view.removeFromSuperview()
            if let rb = view as? ZRadioButton {
                _radioGroup.removeRadioButton(rb)
            }
        }
        if type == type2 {
            return view
        }
        if let type2 = type2 {
            var vs2 = _viewCache[type2] ?? []
            vs2.append(view!)
        }
        guard let type = type else {
            return nil
        }
        if let views = _viewCache[type], !views.isEmpty {
            var vs = views
            let v = vs.remove(at: 0)
            _viewCache[type] = vs
            return v
        }
        return createRightView(type)
    }
    
    private func createRightView(_ type: ZListItemContentType) -> UIView? {
        switch (type) {
        case .Button:
            let btn = ZButton()
            btn.buttonAppearance = _style.itemStyle.buttonAppearence
            btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            return btn
        case .CheckBox:
            let cb = ZCheckBox()
            cb.addTarget(self, action: #selector(checkBoxValueChanged(_:)), for: .valueChanged)
            return cb
        case .RadioButton:
            let rb = ZRadioButton()
            rb.addTarget(self, action: #selector(radioButtonValueChanged(_:)), for: .valueChanged)
            return rb
        case .SwitchButton:
            let sb = ZSwitchButton()
            sb.addTarget(self, action: #selector(switchButtonValueChanged(_:)), for: .valueChanged)
            return sb
        case .TextField:
            let tf = ZTextField(style: _style.itemStyle.textFieldStyle)
            tf.delegate = self
            return tf;
        }
    }
    
    func bindRightView(_ type: ZListItemContentType, _ view: UIView, _ content: Any?) {
        switch type {
        case .Button:
            (view as! ZButton).content = content
        case .TextField:
            let tf = view as! ZTextField
            tf.placeholder = ""
            tf.text = ""
            tf.bounds.width2 = 100
            if let s = content as? String {
                tf.placeholder = s
            }
        case .CheckBox:
            (view as? ZCheckBox)?.checkedState = content as? ZCheckBox.CheckedState ?? .NotChecked
        case .RadioButton:
            if let rb = view as? ZRadioButton {
                rb.checked = content as? Bool ?? false
                _radioGroup.addRadioButton(rb)
            }
        case .SwitchButton:
            (view as? ZSwitchButton)?.isOn = content as? Bool ?? false
        }
    }
    
    private func tapRightView(_ type: ZListItemContentType, _ view: UIView) {
        switch type {
        case .Button:
            buttonClicked(view as! ZButton)
        case .TextField:
            break
        case .CheckBox:
            (view as? ZCheckBox)?.toggle()
        case .RadioButton:
            (view as? ZRadioButton)?.toggle()
        case .SwitchButton:
            (view as? ZSwitchButton)?.toggle()
        }
    }
    
    private func listItemChanged(_ view: UIView, _ value: Any?) {
        guard let cell = view.superview(ofType: ZListViewCell.self) else { return }
        guard let index =  indexPath(for: cell) else { return }
        listDelegate?.listView?(self, itemAt: index, changedTo: value)
    }
    
    @objc private func checkBoxValueChanged(_ sender: ZCheckBox) {
        listItemChanged(sender, sender.checkedState)
    }
    
    @objc private func buttonClicked(_ sender: ZButton) {
        listItemChanged(sender, nil)
    }
    
    @objc private func radioButtonValueChanged(_ sender: ZRadioButton) {
        listItemChanged(sender, sender.checked)
    }
    
    @objc private func switchButtonValueChanged(_ sender: ZSwitchButton) {
        listItemChanged(sender, sender.isOn)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        listItemChanged(textField, textField.text)
    }

}
