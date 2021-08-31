//
//  IconsController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/14.
//

import Foundation

import UIBase

class IconsController: ComponentController {

    class Styles : ViewStyles {
        
    }
    
    class NamedIcon {
        let name: String
        let url: URL
        init(_ name: String, _ url: URL) {
            self.name = name
            self.url = url
        }
    }
    
    class Model : ViewModel {
        let icons: [ZListItemProtocol]
          
        init(_ component: Component) {
            switch (component) {
            case is SvgIconComponent:
                icons = URLs.svgIcons
                    .sorted() { l, r in l.key < r.key }
                    .map() { k, v in NamedIcon(k, v) }
            case is PngIconComponent:
                icons = URLs.pngIcons
                    .sorted() { l, r in l.key < r.key }
                    .map() { k, v in NamedIcon(k, v) }
            case is DayNightIconComponent:
                icons = URLs.dynamicIcons
                    .sorted() { l, r in l.key < r.key }
                    .map() { k, v in NamedIcon(k, v) }
            default:
                icons = []
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
        tableView.data = model.icons
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }
}

extension IconsController.NamedIcon : ZListItemProtocol {
    var title: String { name }
    var subTitle: String? { "" }
    var icon: Any? { url }
    var contentType: ZListItemContentType? { nil }
    var content: Any? { nil }
    var badge: Any? { nil }
}
