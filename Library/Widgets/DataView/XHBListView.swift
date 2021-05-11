//
//  XHBListView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

public enum XHBListItemContentType {
    case Button
    case TextField
    case CheckBox
    case RadioButton
    case SwitchButton
}

public protocol XHBListItemProtocol {
    
    var title: String { get }
    var subTitle: String? { get }
    var icon: Any? { get }
    var contentType: XHBListItemContentType? { get }
    var content: Any? { get }
    var badge: Any? { get }
}

@objc public protocol XHBListViewDelegate {
    @objc optional func listView(_ listView: XHBListView, itemAt: Int, changedTo: Any?)
}

public class XHBListView : UITableView {
    
    public var data: [XHBListItemProtocol] = []
    
    public var listDelegate: XHBListViewDelegate? = nil
    
    private let _style: XHBListViewStyle
    
    private var _viewCache: [XHBListItemContentType: [UIView]] = [:]
    private var _radioGroup = XHBRadioGroup()
    
    public init(style: XHBListViewStyle = .init()) {
        _style = style
        super.init(frame: .zero, style: .plain)
        super.register(XHBListViewCell.self, forCellReuseIdentifier: "XHBListView")
        super.dataSource = self
        super.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class XHBBaseListItem : XHBListItemProtocol {
    public var title: String = ""
    public var subTitle: String? = nil
    public var icon: Any? = nil
    public var contentType: XHBListItemContentType? = nil
    public var content: Any? = nil
    public var badge: Any? = nil
}

extension XHBListView : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "XHBListView") as! XHBListViewCell
        cell.setStyle(_style.itemStyle)
        cell.bindData(data[indexPath.row], listView: self)
        return cell
    }
    
}

extension XHBListView : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cellForRow(at: indexPath) as! XHBListViewCell
        if let type = data[indexPath.row].contentType {
            tapRightView(type, cell._rightView!)
        }
    }
    
}

extension XHBListView : UITextFieldDelegate {

    func switchRightView(_ type: XHBListItemContentType?, _ view: UIView?, _ type2: XHBListItemContentType?) -> UIView? {
        if let view = view {
            view.removeFromSuperview()
            if let rb = view as? XHBRadioButton {
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
    
    private func createRightView(_ type: XHBListItemContentType) -> UIView? {
        switch (type) {
        case .Button:
            let btn = XHBButton()
            btn.buttonAppearance = _style.itemStyle.buttonAppearence
            btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            return btn
        case .CheckBox:
            let cb = XHBCheckBox()
            cb.addTarget(self, action: #selector(checkBoxValueChanged(_:)), for: .valueChanged)
            return cb
        case .RadioButton:
            let rb = XHBRadioButton()
            rb.addTarget(self, action: #selector(radioButtonValueChanged(_:)), for: .valueChanged)
            return rb
        case .SwitchButton:
            let sb = XHBSwitchButton()
            sb.addTarget(self, action: #selector(switchButtonValueChanged(_:)), for: .valueChanged)
            return sb
        case .TextField:
            let tf = XHBTextField(style: _style.itemStyle.textFieldStyle)
            tf.delegate = self
            return tf;
        }
    }
    
    func bindRightView(_ type: XHBListItemContentType, _ view: UIView, _ content: Any?) {
        switch type {
        case .Button:
            (view as! XHBButton).content = content
        case .TextField:
            let tf = view as! XHBTextField
            tf.placeholder = ""
            tf.text = ""
            tf.bounds.width2 = 100
            if let s = content as? String {
                tf.placeholder = s
            }
        case .CheckBox:
            (view as? XHBCheckBox)?.checkedState = content as? XHBCheckBox.CheckedState ?? .NotChecked
        case .RadioButton:
            if let rb = view as? XHBRadioButton {
                rb.checked = content as? Bool ?? false
                _radioGroup.addRadioButton(rb)
            }
        case .SwitchButton:
            (view as? XHBSwitchButton)?.isOn = content as? Bool ?? false
        }
    }
    
    private func tapRightView(_ type: XHBListItemContentType, _ view: UIView) {
        switch type {
        case .Button:
            buttonClicked(view as! XHBButton)
        case .TextField:
            break
        case .CheckBox:
            (view as? XHBCheckBox)?.toggle()
        case .RadioButton:
            (view as? XHBRadioButton)?.toggle()
        case .SwitchButton:
            (view as? XHBSwitchButton)?.toggle()
        }
    }
    
    private func listItemChanged(_ view: UIView, _ value: Any?) {
        guard let cell = view.superview(ofType: XHBListViewCell.self) else { return }
        guard let index =  indexPath(for: cell) else { return }
        listDelegate?.listView?(self, itemAt: index.row, changedTo: value)
    }
    
    @objc private func checkBoxValueChanged(_ sender: XHBCheckBox) {
        listItemChanged(sender, sender.checkedState)
    }
    
    @objc private func buttonClicked(_ sender: XHBButton) {
        listItemChanged(sender, nil)
    }
    
    @objc private func radioButtonValueChanged(_ sender: XHBRadioButton) {
        listItemChanged(sender, sender.checked)
    }
    
    @objc private func switchButtonValueChanged(_ sender: XHBSwitchButton) {
        listItemChanged(sender, sender.isOn)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        listItemChanged(textField, textField.text)
    }

}
