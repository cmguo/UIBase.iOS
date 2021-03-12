//
//  StyleTableViewCell.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/25.
//

import UIKit
import SnapKit

class StyleTableViewCell: UITableViewCell {
        
    private var styles: ViewStyles = ViewStyles()
    private var style: ComponentStyle? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEditview(_ view: UIView) {
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(150)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setStyle(_ styles: ViewStyles, _ style: ComponentStyle) {
        self.styles = styles
        self.style = style
        textLabel?.text = style.title
        initValue(getValue())
    }
    
    func initValue(_ value: String) {
    }
    
    func setValue(_ value: String) {
        guard let style = style else {
            return
        }
        if let values = style.values {
            if let value = values.first(where: { (v: (String, String)) -> Bool in
                return v.0 == value
            }) {
                style.set(value.1, on: styles)
                return
            }
        }
        style.set(value, on: styles)
    }
    
    func getValue() -> String {
        guard let style = style else {
            return ""
        }
        let value = style.get(on: styles)
        if let values = style.values {
            return values.first(where: { (v: (String, String)) -> Bool in
                return v.1 == value
            })?.0 ?? ""
        }
        return value
    }
    
    func values() -> Array<String> {
        return style?.values?.map({ (v: (String, String)) -> String in
            return v.0
        }) ?? []
    }
    
}
