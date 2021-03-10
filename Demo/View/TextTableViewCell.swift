//
//  TextTableViewCell.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/25.
//

import UIKit

class TextTableViewCell: StyleTableViewCell {

    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addEditview(textField)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initValue(_ value: String) {
        textField.text = value
    }

    @objc func textChanged(_ textField: UITextField) {
        setValue(textField.text ?? "")
    }
}
