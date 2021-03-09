//
//  XHBCheckboxController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class XHBCheckboxController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    class Styles : ViewStyles {
        @objc var disabled = false
        @objc var text: String? = "复选框" // 显示的文字（跟随在后面），附加固定间隔；如果为 nil，则没有间隔

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
        let states = XHBCheckBox.CheckedState.allCases
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    
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
        let checkBox = XHBCheckBox(text: styles.text)
        checkBox.isEnabled = !styles.disabled
        checkBox.checkedState = state
        cell.contentView.addSubview(checkBox)
        checkBox.snp.makeConstraints { (make) in
            make.width.equalTo(checkBox.frame.width)
            make.height.equalTo(checkBox.frame.height)
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
}

