//
//  StylesController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation
import UIKit

public class StylesController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    private var viewStyles: ViewStyles?
    private var styles: [ComponentStyle] = []
    private var expandSyle = 0
    
    let wrapper = UIView()
    private let headerView = UIView()
    private let tableView = UITableView()

    public func switchComponent(_ component: ComponentInfo) {
        viewStyles = component.component.controller.getStyles()
        styles = ComponentStyles.get(styles: viewStyles!).allStyles()
        for s in styles { s._init(on: viewStyles!) }
        tableView.reloadData()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CheckBoxTableViewCell.self, forCellReuseIdentifier: "Bool")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "NSString")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "Int")
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "List")
        tableView.register(DescTableViewCell.self, forCellReuseIdentifier: "Desc")

        view.backgroundColor = UIColor(white: 0, alpha: 0.2)

        
        wrapper.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(wrapper)

        wrapper.addSubview(tableView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        //tableView.tableHeaderView = headerView;
        tableView.dataSource = self
        tableView.delegate = self
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.origin.y = 400
        frame.size.height -= 400
        wrapper.frame = frame
        frame.origin.x = 10
        frame.origin.y = 10
        frame.size.width -= 20
        frame.size.height -= 20
        tableView.frame = frame
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count + (expandSyle > 0 ? 1 : 0)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var position = indexPath.row
        var desc = false
        if expandSyle > 0 && position >= expandSyle {
            desc = position == expandSyle
            position -= 1
        }
        let style = styles[position]
        let type = desc ? "Desc" : (style.values == nil ? style.valueTypeName : "List")
        let cell = tableView.dequeueReusableCell(withIdentifier: type)
            ?? TextTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: type)
        (cell as? StyleTableViewCell)?.setStyle(viewStyles!, style)
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggle(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer? = nil) {
        view.removeFromSuperview()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
    
    private func toggle(_ position: Int) {
        var position = position
        if expandSyle > 0 {
            if expandSyle == position {
                return
            }
            if position > expandSyle {
                position -= 1
            }
        }
        if position == expandSyle - 1 {
            expandSyle = 0
        } else {
            expandSyle = position + 1
        }
        tableView.reloadData()
    }
}
