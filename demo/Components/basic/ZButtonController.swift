//
//  XHBButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase
public
class XHBButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

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
        var sizeMode2 = XHBButton.ButtonSize.Large
        @objc var widthMode = ButtonWidth.WrapContent
        var widthMode2 = XHBButton.ButtonWidth.WrapContent
        @objc var icon: UIImage? = nil
        @objc var text: String = "按钮"
        
        override class func valuesForStyle(name: String) -> NSArray? {
            switch name {
            case "sizeMode":
                return makeValues(enumType: XHBButton.ButtonSize.self)
            case "widthMode":
                return makeValues(enumType: XHBButton.ButtonWidth.self)
            default:
                return nil
            }
        }
        
        override class func descsForStyle(name: String) -> NSArray? {
            switch name {
            case "disabled":
                return ["禁用", "切换到禁用状态"]
            case "loading":
                return ["加载", "切换到加载状态"]
            case "sizeMode":
                return ["尺寸模式", "有下列尺寸模式：大（Large）、中（Middle）、小（Small），默认：Large"]
            case "widthMode":
                return ["宽度模式", "有下列宽度模式：适应内容（WrapContent）、适应布局（MatchParent），默认：WrapContent"]
            default:
                return nil
            }
        }
        
        override func notify(_ name: String) {
            if name == "sizeMode" {
                sizeMode2 = XHBButton.ButtonSize.init(rawValue: sizeMode.rawValue)!
                super.notify("sizeMode2")
            } else if name == "widthMode" {
                widthMode2 = XHBButton.ButtonWidth.init(rawValue: widthMode.rawValue)!
                super.notify("widthMode2")
            } else {
                super.notify(name)
            }
        }
    }
    
    class Model : ViewModel {
        let types = XHBButton.ButtonType.allCases
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    
    public override func getStyles() -> ViewStyles {
        return styles
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.types.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = "\(model.types[indexPath.row])"
        let type = model.types[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cell.textLabel?.text = name
        cell.selectionStyle = .none
        let button = XHBButton(frame: CGRect(), type: type, sizeMode: styles.sizeMode2, widthMode: styles.widthMode2, icon: styles.icon, text: styles.text)
        button.isEnabled = !styles.disabled
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(150)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        return cell
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        styles.listen { (name: String) in
            self.tableView.reloadData()
        }
    }
}

