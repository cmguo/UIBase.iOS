//
//  ZCompoundButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class ZCompoundButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    class Styles : ViewStyles {
        
        @objc static let _disabled = ["禁用", "切换到禁用状态"]
        @objc var disabled = false
        
        @objc static let _text = ["文字", "显示的文字（跟随在后面），附加固定间隔；如果为 nil，则没有间隔"]
        @objc var text: String? = "文字"
    }
    
    class Model : ViewModel {
        let states: [Any]
        init(_ component: Component) {
            if component is ZCheckboxComponent {
                states = ZCheckBox.CheckedState.allCases
            } else if (component is ZRatioButtonComponent) {
                states = [false, true, false, false]
            } else if (component is ZSwitchButtonComponent) {
                states = [false, true]
            } else {
                states = []
            }
        }
    }
    
    private let component: Component
    private let styles = Styles()
    private let model: Model
    private let tableView = UITableView()
    private var buttons: [UIButton] = []
    private var switchs: [ZSwitchButton] = []
    private let radioGroup = ZRadioGroup()

    init (_ component: Component) {
        self.component = component
        model = Model(component)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getStyles() -> ViewStyles {
        return styles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.states.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard component is ZCheckboxComponent else { return nil }
        let cell = self.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        cell.textLabel?.text = "全选"
        cell.backgroundColor = .lightGray
        buttons.insert(buttons.removeLast(), at: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard component is ZCheckboxComponent else { return 0 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = "\(model.states[indexPath.row])"
        let state = model.states[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cell.backgroundColor = .clear
        cell.textLabel?.text = name
        cell.selectionStyle = .none
        let button = createButton(state: state)
        button.addTarget(self, action: #selector(changed(_:)), for: .valueChanged)
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            //make.width.equalTo(button.frame.width)
            //make.height.equalTo(button.frame.height)
            make.centerX.equalToSuperview().offset(75)
            make.centerY.equalToSuperview()
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.frame = view.frame
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        styles.listen { (name: String) in
            if name == "disabled" {
                for b in self.buttons { b.isEnabled = !self.styles.disabled }
                for s in self.switchs { s.isEnabled = !self.styles.disabled }
            } else if name == "text" {
                for b in self.buttons { b.setTitle(self.styles.text) }
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    private func createButton(state: Any) -> UIControl {
        if component is ZCheckboxComponent {
            let button = ZCheckBox(text: styles.text)
            button.checkedState = state as! ZCheckBox.CheckedState
            button.isEnabled = !styles.disabled
            buttons.append(button)
            return button
        } else if (component is ZRatioButtonComponent) {
            let button = ZRadioButton(text: styles.text)
            button.checked = state as! Bool
            button.isEnabled = !styles.disabled
            buttons.append(button)
            radioGroup.addRadioButton(button)
            return button
        } else if (component is ZSwitchButtonComponent) {
            let button = ZSwitchButton()
            button.isOn = state as! Bool
            button.isEnabled = !styles.disabled
            switchs.append(button)
            return button
        } else {
            return UIButton()
        }
    }
    
    private func updateTitle(_ sender: UIControl, value: Any) {
        guard let cell = sender.superview(ofType: UITableViewCell.self) else { return }
        cell.textLabel?.text = "\(value)"
    }
    
    private var _changing = 0
    
    @objc private func changed(_ sender: UIControl) {
        _changing += 1
        if let cb = sender as? ZCheckBox {
            if cb != buttons[0] {
                updateTitle(sender, value: cb.checkedState)
            }
            if _changing == 1 {
                if cb == buttons[0] {
                    for i in 1...3 {
                        (buttons[i] as! ZCheckBox).checkedState = cb.checkedState
                    }
                } else {
                    var n = 0
                    for i in 1...3 {
                        if (buttons[i] as! ZCheckBox).checkedState == .FullChecked {
                            n += 1
                        }
                    }
                    (buttons[0] as! ZCheckBox).checkedState = [.NotChecked, .HalfChecked, .HalfChecked, .FullChecked][n]
                }
            }
        } else if let rb = sender as? ZRadioButton {
            updateTitle(sender, value: rb.checked)
        } else if let sb = sender as? ZSwitchButton {
            updateTitle(sender, value: sb.isOn)
        }
        _changing -= 1
    }
}

