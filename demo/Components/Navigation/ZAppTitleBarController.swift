//
//  ZAppTitleBarController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation
import UIBase

class ZAppTitleBarController: ComponentController, ZTitleBarDelegate {

    class Styles : ViewStyles {
        
        @objc static let _leftButton = ["左侧按钮", "左侧按钮的内容，参见按钮的 content 样式"]
        @objc static let _leftButtonStyle = ContentStyle(Styles.self, "leftButton", ["<button>"])
        @objc var leftButton: Any? = URL.icon_left

        @objc static let _rightButton = ["右侧按钮", "右侧按钮的内容，参见按钮的 content 样式"]
        @objc static let _rightButtonStyle = ContentStyle(Styles.self, "rightButton", ["<button>"])
        @objc var rightButton: Any? = URL.icon_more

        @objc static let _rightButton2 = ["右侧按钮2", "右侧第2个按钮的内容，参见按钮的 content 样式"]
        @objc static let _rightButton2Style = ContentStyle(Styles.self, "rightButton2", ["<button>"])
        @objc var rightButton2: Any? = nil

        @objc static let _content = ["内容", "中间或者整体内容，字符串、或者样式集（Dictionary）"]
        @objc static let _contentStyle = ContentStyle(Styles.self, "content", ["<title>"])
        @objc var content: Any? = nil

        @objc static let _data = ["数据", "通过 BindingAdapter 实现的虚拟属性，间接设置给扩展内容，仅用于基于 DataBinding 的布局"]
        @objc var data: Any? = nil

        @objc static let _icon = ["图标", "附加在文字标题左侧的图标，资源ID类型，不能点击"]
        @objc static let _iconStyle = ContentStyle(Styles.self, "icon", ["icon"])
        @objc var icon: Any? = URLs.iconURL("erase")

        @objc static let _title = ["标题", "标题文字，一般在中间显示；如果没有左侧按钮内容，则在左侧大标题样式展示"]
        @objc var title = "标题"

        @objc static let _textAppearance = ["标题样式", "标题样式（TextAppearance），应用于标题；默认样式会根据位置自动计算设置，所以一般不需要设置"]
        @objc var textAppearance: String = "<null>"
        
        var textAppearance2: TextAppearance? {
            return nil
        }
    }
    
    class Model : ViewModel {
    }
    
    private let styles = Styles()
    private let model = Model()
    private let titleBar = ZAppTitleBar()
    private var views = [ZAppTitleBar]()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue_100

        titleBar.title = styles.title
        titleBar.leftButton = styles.leftButton
        titleBar.rightButton = styles.rightButton
        titleBar.icon = styles.icon
        titleBar.delegate = self
        view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
        }
        views.append(titleBar)


        styles.listen { (name: String) in
            if name == "leftButton" {
                for b in self.views { b.leftButton = self.styles.leftButton }
            } else if name == "rightButton" {
                for b in self.views { b.rightButton = self.styles.rightButton }
            } else if name == "rightButton2" {
                for b in self.views { b.rightButton2 = self.styles.rightButton2 }
            } else if name == "icon" {
                for b in self.views { b.icon = self.styles.icon }
            } else if name == "title" {
                for b in self.views { b.title = self.styles.title }
            } else if name == "content" {
                for b in self.views { b.content = self.styles.content }
            } else if name == "textAppearance" {
                for b in self.views { b.textAppearance = self.styles.textAppearance2 }
            }
        }
    }
    
    func titleBarButtonClicked(titleBar: ZAppTitleBar, btnId: ZButton.ButtonId?) {
        ZTipView.toast(titleBar, "点击了按钮 \(btnId ?? .Unknown)")
    }

}

