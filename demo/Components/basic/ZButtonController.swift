//
//  ZButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase
import SwiftSVG

public class ZButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    @objc enum ButtonType : Int {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
    }
    
    @objc enum ButtonSize : Int {
        case Large
        case Middle
        case Small
        case Thin
    }
    
    @objc enum ButtonWidth : Int {
        case WrapContent
        case MatchParent
    }
    
    @objc enum IconPosition : Int {
        case Left
        case Top
        case Right
        case Bottom
    }
    
    class Styles : ViewStyles {
        
        @objc static let _disabled = ["禁用", "切换到禁用状态"]
        @objc var disabled = false
        
        @objc static let _loading = ["加载", "切换到加载状态"]
        @objc var loading = false
        
        @objc static let _sizeMode = ["尺寸模式", "切换到尺寸演示模式"]
        @objc var sizeMode = false
        
        @objc static let _buttonType = ["颜色模式", "有下列颜色模式：主要（Primitive）、二级（Secondary）、三级（Tertiary）、危险（Danger）、文字（TextLink），默认：Primitive"]
        @objc static let _buttonTypeStyle: NSObject = EnumStyle(Styles.self, "buttonType", ZButtonAppearance.ButtonType.self)
        @objc var buttonType = ButtonType.Primitive
        
        @objc static let _buttonSize = ["尺寸模式", "有下列尺寸模式：大（Large）、中（Middle）、小（Small），默认：Large"]
        @objc static let _buttonSizeStyle: NSObject = EnumStyle(Styles.self, "buttonSize", ZButtonAppearance.ButtonSize.self)
        @objc var buttonSize = ButtonSize.Large

        @objc static let _widthMode = ["宽度模式", "有下列宽度模式：适应内容（WrapContent）、适应布局（MatchParent），默认：WrapContent"]
        @objc static let _widthModeStyle: NSObject = EnumStyle(Styles.self, "widthMode", ZButtonAppearance.ButtonWidth.self)
        @objc var widthMode = ButtonWidth.WrapContent
        
        @objc static let _iconPosition = ["图标位置", "更改图标位置，可以在文字上下或者左右"]
        @objc static let _iconPositionStyle: NSObject = EnumStyle(Styles.self, "iconPosition", ZButtonAppearance.IconPosition.self)
        @objc var iconPosition = IconPosition.Left
        
        @objc static let _icon = ["显示图标", "更改图标，URL 类型，按钮会自动适应宽度"]
        @objc static let _iconStyle: NSObject = IconStyle(Styles.self, "icon")
        @objc var icon: URL? = Icons.iconURL("delete")
        
        @objc static let _text = ["显示文字", "改变文字，按钮会自动适应文字宽度"]
        @objc var text: String = "按钮"
        
        @objc static let _content = ["内容", "包含文字或者图标，或者文字和图标及样式集"]
        @objc static let _contentStyle = ContentStyle(Styles.self, "content", ["<button>"])
        @objc var content: Any? = nil
        
        var buttonType2: ZButtonAppearance.ButtonType {
            get { ZButtonAppearance.ButtonType.init(rawValue: buttonType.rawValue)! }
        }
        
        var buttonSize2: ZButtonAppearance.ButtonSize {
            get { ZButtonAppearance.ButtonSize.init(rawValue: buttonSize.rawValue)! }
        }

        var widthMode2: ZButtonAppearance.ButtonWidth {
            get { ZButtonAppearance.ButtonWidth.init(rawValue: widthMode.rawValue)! }
        }

        var iconPosition2: ZButtonAppearance.IconPosition {
            get { ZButtonAppearance.IconPosition.init(rawValue: iconPosition.rawValue)! }
        }
    }
    
    class Model : ViewModel {
        let types = ZButtonAppearance.ButtonType.allCases
        let sizes = ZButtonAppearance.ButtonSize.allCases
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    private var buttons: [ZButton] = []
    
    override func getStyles() -> ViewStyles {
        return styles
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.sizeMode ? model.sizes.count :  model.types.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "")
        cell.backgroundColor = .clear
        let button = ZButton()
            .buttonSize(styles.buttonSize2)
            .text(styles.text)
            .icon(styles.icon)
        if !styles.sizeMode {
            let name = "\(model.types[indexPath.row])"
            let type = model.types[indexPath.row]
            cell.textLabel?.text = name
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = String(format: "textColor: %1$@\nbackgroundColor: %2$@",  Colors.colorName(type.value.textColor!), Colors.colorName(type.value.backgroundColor!))
            button.buttonType(type)
        } else {
            let name = "\(model.sizes[indexPath.row])"
            let size = model.sizes[indexPath.row]
            cell.textLabel?.text = name
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = String(format: "height: %1$@, radius: %2$@, padding: %2$@\ntextSize: %3$@, iconSize: %3$@, iconPadding: %3$@", String(Int(size.value.height!)), String(Int(size.value.radius!)), String(Int(size.value.padding!)), String(Int(size.value.textSize!)), String(Int(size.value.iconSize!)), String(Int(size.value.iconPadding!)))
            button.buttonSize(size)
        }
        cell.selectionStyle = .none
        button.isEnabled = !styles.disabled
        button.isLoading = self.styles.loading
        button.iconPosition = styles.iconPosition2
        buttons.append(button)
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            if (styles.widthMode == .MatchParent) {
                make.leading.equalToSuperview().offset(150)
                make.trailing.equalToSuperview()
            } else {
                //make.width.equalTo(button.bounds.width)
                make.centerX.equalToSuperview().offset(75)
            }
            //make.height.equalTo(button.frame.height)
            make.centerY.equalToSuperview()
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 //UITableView.automaticDimension
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.frame = view.bounds
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        styles.listen { (name: String) in
            if name == "disabled" {
                for b in self.buttons { b.isEnabled = !self.styles.disabled }
            } else if name == "loading" {
                for b in self.buttons { b.isLoading = self.styles.loading }
            } else if name == "buttonType" {
                for b in self.buttons { b.buttonType2 = self.styles.buttonType2 }
            } else if name == "buttonSize" {
                for b in self.buttons { b.buttonSize = self.styles.buttonSize2 }
            } else if name == "iconPosition" {
                for b in self.buttons { b.iconPosition = self.styles.iconPosition2 }
            } else if name == "icon" {
                for b in self.buttons { b.icon = self.styles.icon }
            } else if name == "text" {
                for b in self.buttons { b.text = self.styles.text }
            } else if name == "content" {
                for b in self.buttons { b.content = self.styles.content }
            } else {
                self.buttons.removeAll()
                self.tableView.reloadData()
            }
        }
    }
}

