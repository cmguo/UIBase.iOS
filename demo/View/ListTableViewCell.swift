//
//  ListTableViewCell.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/25.
//

import UIKit

class ListTableViewCell: StyleTableViewCell {

    let label = UITextField()
    let dropBox: DropBoxTextField
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        dropBox = DropBoxTextField(frame: CGRect(x: 0, y:0, width: 200, height: 44), customTextField: label)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.isEnabled = false
        addEditview(dropBox)
        dropBox.didSelectedAt = { [weak self](index, title, textField) in
            self?.selectedChanged(text: title)
            self?.dropBox.drawUp()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initValue(_ value: String) {
        label.text = value
        let values = self.values()
        dropBox.count = values.count
        dropBox.itemForRowAt = { (index) -> (String, UIImage?) in
            return (values[index], nil)
        }
    }
    
    @objc func selectedChanged(text: String) {
        setValue(text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dropBox.endEditing(false);
    }
}
