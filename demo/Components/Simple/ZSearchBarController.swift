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
        
    }
    
    class Model : ViewModel {
    }
    
    private let styles = Styles()
    private let model = Model()
    private let searchBar = ZSearchBar()
    private var views = [ZSearchBar]()

    private let label = UILabel()
    private let text = UILabel()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        label.text = "当前数值"
        view.addSubview(label)
        view.addSubview(text)
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(120)
            maker.bottom.equalToSuperview().offset(-100)
        }
        text.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.top)
            maker.leading.equalTo(label.snp.trailing).offset(20)
        }
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
        }
        views.append(searchBar)


        styles.listen { (name: String) in
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
}

