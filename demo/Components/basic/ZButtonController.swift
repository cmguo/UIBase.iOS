//
//  ZButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class ZButtonController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComponentController {

    enum ButtonType {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
    }
    
    enum ButtonSize {
        case Small
        case Middle
        case Large
    }
    
    enum ButtonWidth {
        case WrapContent
        case MatchParent
    }
    
    class Styles : NSObject {
        public var disabled = false
        public var loading = false
        public var sizeMode = ButtonSize.Large
        public var widthMode = ButtonWidth.WrapContent
        public var icon: CGImage? = nil
    }
    
    class Model : ViewModel {
        let colors = Colors.stdColors()
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    
    func getStyles() -> NSObject {
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

