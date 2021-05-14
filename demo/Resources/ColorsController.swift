//
//  ColorsController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation
import UIBase

class ColorsController: ComponentController {

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
    class NamedStateListColor {
        let name: String
        let color: StateListColor
        init(_ name: String, _ color: StateListColor) {
            self.name = name
            self.color = color
        }
    }
    
    class Model : ViewModel {
        let colors: [ZListItemProtocol]
          
        init(_ component: Component) {
            switch (component) {
            case is DayNightColorsComponent:
                colors = Colors.stdDynamicColors()
                    .sorted() { l, r in l.key < r.key }
                    .map() { k, v in NamedColor(k, v) }
            case is StaticColorsComponent:
                colors = Colors.stdStaticColors()
                    .sorted() { l, r in l.key < r.key }
                    .map() { k, v in NamedColor(k, v) }
            case is StateListColorsComponent:
                colors = Colors.stateListColors()
                    .sorted() { l, r in l.key < r.key }
                    .map() { k, v in NamedStateListColor(k, v) }
            default:
                colors = []
            }
        }
    }
    

    private let styles = Styles()
    private let model: Model
    private let tableView = ZListView(style: {
        let style = ZListViewStyle()
        style.headerStyle.backgroundColor = .clear
        style.itemStyle.backgroundColor = .clear
        return style
    }())
    
    init(_ component: Component) {
        model = Model(component)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getStyles() -> ViewStyles {
        return self.styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        tableView.data = model.colors
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }
}

extension ColorsController.NamedColor : ZListItemProtocol {
    var title: String { name }
    var subTitle: String? { color.hexString() }
    var icon: Any? { color }
    var contentType: ZListItemContentType? { nil }
    var content: Any? { nil }
    var badge: Any? { nil }
}

private let stateNames: [UIControl.State: String] = [
    .disabled: "disabled", .highlighted: "highlighted",
    .selected: "selected", .focused: "focused",
    .STATE_CHECKED: "CHECKED", .STATE_HALF_CHECKED: "HALF_CHECKED",
    .STATE_ERROR: "ERROR"
]

extension StateColor : ZListItemProtocol {
    
    public var title: String { color.hexString() }
    public var subTitle: String? {
        var s = states.rawValue
        var t: UInt = 1
        var strs: [String] = []
        while s != 0 {
            if (s & t) != 0 {
                s = s ^ t
                strs.append(stateNames[UIControl.State(rawValue: t)]!)
            }
            t = t << 1
        }
        return strs.joined(separator: ", ")
    }
    public var icon: Any? { color }
    public var contentType: ZListItemContentType? { nil }
    public var content: Any? { nil }
    public var badge: Any? { nil }
}

extension ColorsController.NamedStateListColor : ZListSectionProtocol {
    var title: String { name }
    var items: [ZListItemProtocol] { color.statesColors }
    var subTitle: String? { nil }
    var icon: Any? { nil }
    var contentType: ZListItemContentType? { nil }
    var content: Any? { nil }
    var badge: Any? { nil }
}
