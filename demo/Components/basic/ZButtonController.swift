//
//  XHBButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase
import SwiftSVG

public class XHBButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

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
        @objc var iconAtRight = false
        @objc var icon: String = "delete"
        @objc var text: String = "按钮"
        
        override class func valuesForStyle(name: String) -> NSArray? {
            switch name {
            case "sizeMode":
                return makeValues(enumType: XHBButton.ButtonSize.self)
            case "widthMode":
                return makeValues(enumType: XHBButton.ButtonWidth.self)
            case "icon":
                return Icons.icons as NSArray
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
            case "iconAtRight":
                return ["图标右置", "更改图标位置，可以在文字左边或者右边"]
            case "icon":
                return ["显示图标", "更改图标，URL 类型，按钮会自动适应宽度"]
            case "text":
                return ["显示文字", "改变文字，按钮会自动适应文字宽度"]
           default:
                return nil
            }
        }
        
        override func notify(_ name: String) {
            if name == "sizeMode" {
                sizeMode2 = XHBButton.ButtonSize.init(rawValue: sizeMode.rawValue)!
            } else if name == "widthMode" {
                widthMode2 = XHBButton.ButtonWidth.init(rawValue: widthMode.rawValue)!
            }
            super.notify(name)
        }
    }
    
    class Model : ViewModel {
        let types = XHBButton.ButtonType.allCases
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    private var buttons: [XHBButton] = []
    
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
        let button = XHBButton(type: type, sizeMode: styles.sizeMode2, icon: Icons.iconURL(styles.icon), text: styles.text)
        button.isEnabled = !styles.disabled
        button.isLoading = self.styles.loading
        buttons.append(button)
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            if (styles.widthMode == .MatchParent) {
                make.leading.equalToSuperview().offset(150)
                make.trailing.equalToSuperview()
            } else {
                make.width.equalTo(button.bounds.width)
                make.centerX.equalToSuperview().offset(75)
            }
            make.height.equalTo(button.frame.height)
            make.centerY.equalToSuperview()
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 //UITableView.automaticDimension
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        styles.listen { (name: String) in
            if name == "disabled" {
                for b in self.buttons { b.isEnabled = !self.styles.disabled }
            } else if name == "loading" {
                for b in self.buttons { b.isLoading = self.styles.loading }
//            } else if name == "sizeMode" {
//                for b in self.buttons { _ = b }
//                self.view.setNeedsLayout()
            } else if name == "iconAtRight" {
                for b in self.buttons { b.iconAtRight = self.styles.iconAtRight }
                self.view.setNeedsLayout()
            } else if name == "icon" {
                for b in self.buttons { b.icon = Icons.iconURL(self.styles.icon) }
                self.view.setNeedsLayout()
            } else if name == "text" {
                for b in self.buttons { b.text = self.styles.text }
                self.view.setNeedsLayout()
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    public override func viewWillLayoutSubviews() {
        if styles.widthMode2 == .WrapContent {
            for b in self.buttons {
                b.snp.updateConstraints { (maker) in
                    maker.width.equalTo(b.bounds.width)
                    maker.height.equalTo(b.bounds.height)
                }
            }
        }
    }
}

