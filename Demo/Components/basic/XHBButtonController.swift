//
//  XHBButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit

class XHBButtonController: ComponentController, UITableViewDataSource, UITableViewDelegate {

    enum ButtonType {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
    }
    
    @objc enum ButtonSize : Int {
        case Small
        case Middle
        case Large
    }
    
    enum ButtonSize2 : Int, RawRepresentable, CaseIterable {
        case Small
        case Middle
        case Large
    }
    
    @objc enum ButtonWidth : Int {
        case WrapContent
        case MatchParent
    }
    
    enum ButtonWidth2 : Int, RawRepresentable, CaseIterable {
        case WrapContent
        case MatchParent
    }
    
    class Styles : ViewStyles {
        @objc var disabled = false
        @objc var loading = false
        @objc var sizeMode = ButtonSize.Large
        var sizeMode2 = ButtonSize2.Large
        @objc var widthMode = ButtonWidth.WrapContent
        var widthMode2 = ButtonWidth2.WrapContent
        @objc var icon: UIImage? = nil
        
        override class func valuesForStyle(name: String) -> NSArray? {
            switch name {
            case "sizeMode":
                return makeValues(enumType: ButtonSize2.self)
            case "widthMode":
                return makeValues(enumType: ButtonWidth2.self)
            default:
                return nil
            }
        }
        
        override func notify(_ name: String) {
            if name == "sizeMode" {
                sizeMode2 = ButtonSize2.init(rawValue: sizeMode.rawValue)!
                super.notify("sizeMode2")
            } else if name == "widthMode" {
                widthMode2 = ButtonWidth2.init(rawValue: widthMode.rawValue)!
                super.notify("widthMode2")
            }
        }
    }
    
    class Model : ViewModel {
        let colors = Colors.stdColors()
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tableView = UITableView()
    
    override func getStyles() -> ViewStyles {
        return styles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = model.colors.index(model.colors.startIndex, offsetBy: indexPath.row)
        let name = model.colors.keys[index]
        let color = model.colors.values[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "")
            ?? UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cell.textLabel?.text = name
        cell.textLabel?.backgroundColor = color
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        styles.listen { (name: String) in
            switch name {
            case "disabled":
                break;
            case "loading":
                break;
            case "sizeMode2":
                break;
            case "widthMode2":
                break;
            default:
                break;
            }
        }
    }
}

