//
//  StylesController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation
import UIKit

public class StylesController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var viewStyles: ViewStyles?
    private var styles: Array<ComponentStyle> = []
    
    private let headerView = UIView()
    private let tableView = UITableView()

    public func switchComponent(_ component: Component) {
        viewStyles = component.controller.getStyles()
        styles = ComponentStyles.get(styles: viewStyles!).allStyles()
        tableView.reloadData()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableHeaderView = headerView;
        tableView.dataSource = self
        tableView.delegate = self
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = styles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: style.valyeTypeName)
            ?? UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: style.valyeTypeName)
        cell.textLabel?.text = style.title
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
