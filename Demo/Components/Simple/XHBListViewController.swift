//
//  XHBListViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/8.
//

import Foundation
import UIBase

class XHBListViewController: ComponentController, XHBListViewDelegate {

    class Styles : ViewStyles {
        
    }
    
    class NamedColor {
        let name: String
        let color: UIColor
        init(_ name: String, _ color: UIColor) {
            self.name = name
            self.color = color
        }
    }
    
    class Model : ViewModel {
        let colors = Colors.stdDynamicColors()
            .sorted() { l, r in l.key < r.key }
            .map() { k, v in NamedColor(k, v) }
    }
    
    private let styles = Styles()
    private let model = Model()

    private let tableView = XHBListView()

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
            default:
                break
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func listView(_ listView: XHBListView, itemAt: Int, changedTo: Any?) {
        guard let cell = listView.cellForRow(at: IndexPath(row: itemAt, section: 0)) else { return }
        let value = changedTo ?? "null"
        XHBTipView.tip(cell, "Item \(itemAt) 改变为 \(value)")
    }
}

extension XHBListViewController.NamedColor : XHBListItemProtocol {
    
    var title: String {
        name
    }
    
    var subTitle: String? {
        if name.contains("600") {
            return nil
        }
        return color.description
    }
    
    var icon: Any? {
        color
    }
    
    var contentType: XHBListItemContentType? {
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
    
    var badge: Any? {
        nil
    }
    
    
}
