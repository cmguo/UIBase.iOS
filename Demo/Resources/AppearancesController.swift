//
//  AppearancesController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/14.
//

import Foundation

import UIBase

class AppearancesController: ComponentController {

    class Styles : ViewStyles {
        
    }
    
    class Model : ViewModel {
        
        let styles: [(String, Any)]
          
        init(_ component: Component) {
            switch (component) {
            case is TextAppearanceComponent:
                styles = Appearances.textAppearances()
                    .sorted() { l, r in l.key < r.key}
                    .map() { k, v in (k, v) }
            default:
                styles = []
            }
        }
    }

    private let styles = Styles()
    private let model: Model
    private let tableView = UITableView()
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Appearances")
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
}

extension AppearancesController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.styles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Appearances", for: indexPath)
        let style = model.styles[indexPath.row]
        let appearance = style.1 as! TextAppearance
        cell.textLabel?.text = String(format: "文字样式： %1$@\nsize: %2$@, color: %3$@", style.0, String(Int(appearance.textSize)), Colors.colorName(appearance.textColors))
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAppearance = appearance
        return cell
    }
}
