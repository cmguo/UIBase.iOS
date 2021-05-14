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
        
        let styles: [String: Any]
          
        init(_ component: Component) {
            switch (component) {
            case is TextAppearanceComponent:
                styles = Appearances.textAppearances()
            default:
                styles = [:]
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
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
}
