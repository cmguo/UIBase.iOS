//
//  ZTextInputController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZTextInputController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum TextInputSize {
        case Small
        case Middle
        case Large
    }
    
//    enum TextInputState {
//        case Normal
//        case Foucsed
//        case Error
//        case Disabled
//    }
    
    class Styles : ViewStyles {
        var disabled = false
        // var focused = false
        var verifier: ((String) -> Bool)? = nil // 输入联想，返回补全的文字
        // var complementer: ((String) -> String)? = nil // 输入联想，返回补全的文字
        var hasClearButton = false
        var sizeMode = TextInputSize.Large
        var maximumCharCount = 0 // 最大字数，设为0不限制；如果有限制，将展现字数指示
        var placeHolder = "请输入" // 没有任何输入文字时，显示的占位文字（灰色）
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

