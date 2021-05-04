//
//  ZTextInputController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZTextInputController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    @objc enum TextInputSize : Int {
        case Small
        case Middle
        case Large
    }
    
    class Styles : ViewStyles {
        @objc var disabled = false
        // var focused = false
        @objc var verifier: ((String) -> Bool)? = nil // 输入联想，返回补全的文字
        // var complementer: ((String) -> String)? = nil // 输入联想，返回补全的文字
        @objc var hasClearButton = false
        @objc var sizeMode = TextInputSize.Large
        @objc var maximumCharCount = 0 // 最大字数，设为0不限制；如果有限制，将展现字数指示
        @objc var placeHolder = "请输入" // 没有任何输入文字时，显示的占位文字（灰色）
    }
    
    class Model : ViewModel {
        let colors = Colors.stdDynamicColors()
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    
    override func getStyles() -> ViewStyles {
        return styles
    }
    
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

