//
//  XHBCompoundButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class XHBCompoundButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    class Styles : ViewStyles {
        @objc var disabled = false
        @objc var text: String? = "文字" // 显示的文字（跟随在后面），附加固定间隔；如果为 nil，则没有间隔

        override class func descsForStyle(name: String) -> NSArray? {
            switch name {
            case "disabled":
                return ["禁用", "切换到禁用状态"]
            case "text":
                return ["显示文字", "改变文字，按钮会自动适应文字宽度"]
            default:
                return nil
            }
        }
    }
    
    class Model : ViewModel {
        let states: [Any]
        init(_ component: Component) {
            if component is XHBCheckboxComponent {
                states = XHBCheckBox.CheckedState.allCases
            } else if (component is XHBRatioButtonComponent) {
                states = [false, true]
            } else if (component is XHBSwitchButtonComponent) {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = "\(model.states[indexPath.row])"
        let state = model.states[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cell.textLabel?.text = name
        cell.selectionStyle = .none
        let button: UIView = createButton(state: state)
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(button.frame.width)
            make.height.equalTo(button.frame.height)
            make.centerX.equalToSuperview().offset(75)
            make.centerY.equalToSuperview()
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        styles.listen { (name: String) in
            self.tableView.reloadData()
        }
    }
    
    func createButton(state: Any) -> UIView {
        if component is XHBCheckboxComponent {
            let button = XHBCheckBox(text: styles.text)
            button.checkedState = state as! XHBCheckBox.CheckedState
            button.isEnabled = !styles.disabled
            return button
        } else if (component is XHBRatioButtonComponent) {
            let button = XHBRadioButton(text: styles.text)
            button.checked = state as! Bool
            button.isEnabled = !styles.disabled
            return button
        } else if (component is XHBSwitchButtonComponent) {
            let button = XHBSwitchButton()
            button.isOn = state as! Bool
            button.isEnabled = !styles.disabled
            return button
        } else {
            return UIButton()
        }
    }
}

