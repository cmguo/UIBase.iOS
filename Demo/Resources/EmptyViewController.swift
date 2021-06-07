//
// Created by Crap on 2021/6/3.
//

import Foundation
import SwiftUI
import SnapKit
import UIBase

class EmptyViewController: ComponentController , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UITableViewCell()
    }


    override func getStyles() -> ViewStyles {
        return ViewStyles()
    }

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        let btn = ZButton()
        btn.text = "测试按钮"
        btn.addTarget(self, action: #selector(onClick), for: .touchUpInside)

        view.addSubview(btn)

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.separatorStyle = .none

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        btn.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }

    var index = 0

    @objc func onClick() {
        let v = index % 4
        index += 1
        switch v {
        case 0:
            tableView.uibase_emptyViewDefault = ZEmptyViewData.build(text: "数据为空", listener: {
                self.onClick()
            })
        case 1:
            tableView.uibase_emptyViewDefault = ZEmptyViewData.build(text: "数据错误", listener: {
                self.onClick()
            })
        case 2:
            tableView.uibase_emptyViewDefault = ZEmptyViewData.build(loading: true)
        case 3:
            tableView.uibase_emptyViewDefault = nil
        default:
            break
        }
    }

}
