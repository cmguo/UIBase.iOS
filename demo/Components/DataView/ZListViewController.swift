//
//  ZListViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation
import UIBase

class ZListViewController: ComponentController, ZListViewDelegate {

    class Styles : ViewStyles {
        
        @objc static let _group = ["分组", "演示分组列表"]
        @objc var group = false
        
    }
    
    class NamedColor {
        let name: String
        let color: UIColor
        init(_ name: String, _ color: UIColor) {
            self.name = name
            self.color = color
        }
    }
    
    class NamedColorGroup {
        let name: String
        let colors: [NamedColor]
        init(_ name: String, _ colors: [NamedColor]) {
            self.name = name
            self.colors = colors.filter() { c in c.name.hasPrefix(name) }
        }
    }
    
    class Model : ViewModel {
        
        let colors: [ZListItemProtocol]
        
        let colorGroups: [ZListItemProtocol]
        
        override init() {
            let colors = Colors.stdDynamicColors()
                .sorted() { l, r in l.key < r.key }
                .map() { k, v in NamedColor(k, v) }
            self.colors = colors
            self.colorGroups = ["bluegrey", "blue", "red", "brand", "cyan", "green", "purple", "redorange"].map() { name in
                NamedColorGroup(name, colors)
            }
        }
    }
    
    private let styles = Styles()
    private let model = Model()

    private let tableView = ZListView()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.data = model.colors
        tableView.listDelegate = self
        view.addSubview(tableView)

        styles.listen { (name: String) in
            switch name {
            case "group":
                self.tableView.data = self.styles.group ? self.model.colorGroups : self.model.colors
            default:
                break
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func listView(_ listView: ZListView, itemAt: IndexPath, changedTo: Any?) {
        guard let cell = listView.cellForRow(at: itemAt) else { return }
        let value = changedTo ?? "null"
        ZTipView.tip(cell, "Item \(itemAt) 改变为 \(value)", .topCenter)
    }
}

extension ZListViewController.NamedColor : ZListItemProtocol {
    
    var title: String { name  }
    var icon: Any? { color }
    var badge: Any? { nil }

    var subTitle: String? {
        if name.contains("600") {
            return nil
        }
        return CIColor(cgColor: color.cgColor).stringRepresentation
    }
    
    var contentType: ZListItemContentType? {
        switch color {
        case .blue_100:
            return .Button
        case .bluegrey_100:
            return .CheckBox
        case .bluegrey_300:
            return .CheckBox
        case .bluegrey_800:
            return .RadioButton
        case .bluegrey_900:
            return .RadioButton
        case .brand_600:
            return .TextField
        case .red_600:
            return .SwitchButton
        default:
            return nil
        }
    }
    
    var content: Any? {
        switch color {
        case .blue_100:
            return ContentStyle.Contents["button_goto"]
        case .bluegrey_800:
            return true
        case .brand_600:
            return "请输入"
        default:
            return nil
        }
    }
}

extension ZListViewController.NamedColorGroup : ZListSectionProtocol {
    var title: String { name }
    var subTitle: String? { nil }
    var icon: Any? { nil }
    var items: [ZListItemProtocol] { colors }
    var contentType: ZListItemContentType? { nil }
    var content: Any? { nil }
    var badge: Any? { nil }
}
