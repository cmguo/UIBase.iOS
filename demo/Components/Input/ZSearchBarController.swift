//
//  ZSearchBarController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation
import UIBase

class ZSearchBarController: ComponentController, UISearchBarDelegate {

    class Styles : ViewStyles {
        
        @objc static let _placeholder = ["占位文字", "没有任何输入文字时，显示的占位文字（灰色）"]
        @objc var placeholder = "请输入"
        
    }
    
    class Model : ViewModel {
        let colors = Array(Colors.stdDynamicColors().keys)
        var filterColors: [String] = []
        var filter: String = "" {
            didSet {
                filterColors = filter == "" ? colors : Array(colors.filter() { s in s.contains(self.filter) })
            }
        }
        override init() {
            filterColors = colors
        }
    }
    
    private let styles = Styles()
    private let model = Model()
    private let searchBar = ZSearchBar()
    private var views = [ZSearchBar]()

    private let tableView = UITableView()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
        }
        views.append(searchBar)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Result")
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(searchBar.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }

        styles.listen { (name: String) in
            switch name {
            case "placeholder":
                for b in self.views { b.placeholder = self.styles.placeholder }
            default:
                break
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.filter = searchText
        tableView.reloadData()
    }
    
}

extension ZSearchBarController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.filterColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Result")!
        cell.textLabel?.text = model.filterColors[indexPath.row]
        return cell
    }
    
}
