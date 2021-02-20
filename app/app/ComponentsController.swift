//
//  ToolController.swift
//  app
//
//  Created by 郭春茂 on 2021/2/20.
//

import UIKit
import demo

class ComponentsController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var components_: [String: Array<Component>] = Components.allGroups()
    
    private let headerView = UIView()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableHeaderView = headerView;
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = components_.index(components_.startIndex, offsetBy: section)
        return components_.values[index].count
    }
    
    static private let cellId = "SimpleTableId"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = components_.index(components_.startIndex, offsetBy: indexPath.section)
        let component = components_.values[index][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ComponentsController.cellId)
            ?? UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: ComponentsController.cellId)
        cell.textLabel?.text = component.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return components_.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = components_.index(components_.startIndex, offsetBy: section)
        return components_.keys[index]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = components_.index(components_.startIndex, offsetBy: indexPath.section)
        let component = components_.values[index][indexPath.row]
        (parent as? ViewController)?.switchComponent(component)
    }

}
