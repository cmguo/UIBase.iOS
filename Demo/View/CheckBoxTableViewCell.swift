//
//  CheckBoxTableViewCell.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/25.
//

import UIKit

class CheckBoxTableViewCell: StyleTableViewCell {

    var checkBox = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addEditview(checkBox)
        checkBox.addTarget(self, action: #selector(checkedChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initValue(_ value: String) {
        checkBox.setOn(value == "true", animated: false)
    }

    @objc func checkedChanged(_ checked: Bool) {
        setValue(checked.description)
    }
}
