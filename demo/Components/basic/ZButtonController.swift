//
//  ZButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    enum ButtonType {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
    }
    
    @objc enum ButtonSize : Int {
        case Small
        case Middle
        case Large
    }
    
    @objc enum ButtonWidth : Int {
        case WrapContent
        case MatchParent
    }
    
    class Styles : ViewStyles {
        @objc var disabled = false
        @objc var loading = false
        @objc var sizeMode = ButtonSize.Large
        @objc var widthMode = ButtonWidth.WrapContent
        @objc var icon: UIImage? = nil
    }
    
    class Model : ViewModel {
        let colors = Colors.stdColors()
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

