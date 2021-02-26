//
//  DescTableViewCell.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/26.
//

import UIKit

class DescTableViewCell: StyleTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle(_ styles: ViewStyles, _ style: ComponentStyle) {
        textLabel?.text = style.desc
    }
    
}
