//
//  ZCheckboxController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZCheckboxController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum CheckboxState {
        case Normal
        case Checked
        case HalfChecked
        case Disabled
        case DisabledChecked
    }
    
    class Styles : ViewStyles {
        var state = CheckboxState.Normal
        var text: String? = "复选框" // 显示的文字（跟随在后面），附加固定间隔；如果为 nil，则没有间隔
    }
    
    class Model : ViewModel {
        let colors = Colors.stdColors()
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = model.colors.index(model.colors.startIndex, offsetBy: indexPath.row)
        let name = model.colors.keys[index]
        let color = model.colors.values[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "")
            ?? UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cell.textLabel?.text = name
        cell.textLabel?.backgroundColor = color
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
    }
}

