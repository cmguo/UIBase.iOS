//
//  XHBPanelController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/21.
//

import Foundation
import UIBase

class XHBPanelController: ComponentController, XHBPanelCallbackDelegate {

    class Styles : ViewStyles {
        
        @objc static let _bottomButton = ["底部按钮", "底部按钮的内容，参见按钮的 content 样式"]
        @objc static let _bottomButtonStyle = ContentStyle(Styles.self, "bottomButton", ["<button>"])
        @objc var bottomButton: Any? = nil

        @objc static let _content = ["内容", "中间或者整体内容，UIView 实例或者样式集（Dictionary）"]
        @objc static let _contentStyle = ContentStyle(Styles.self, "content", ["@Dictionary", "@UIView", "@String"])
        @objc var content: Any? = nil

        @objc static let _data = ["数据", "通过 BindingAdapter 实现的虚拟属性，间接设置给扩展内容，仅用于基于 DataBinding 的布局"]
        @objc var data: Any? = nil

        @objc static let _titleBar = ["顶部栏", "顶部标题栏栏，可选，参见标题栏的 content 样式"]
        @objc static let _titleBarStyle = ContentStyle(Styles.self, "titleBar", ["<title>"])
        @objc var titleBar: Any? = "title_text"
    }
    
    class Model : ViewModel {
    }
    
    private let styles = Styles()
    private let model = Model()
    private let panel = XHBPanel()
    private var views = [XHBPanel]()
    
    private let button = XHBButton()


    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        panel.titleBar = styles.titleBar
        panel.bottomButton = styles.bottomButton
        panel.delegate = self
        view.addSubview(panel)
        panel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.top.equalToSuperview().offset(20)
        }
        views.append(panel)

        button.text = "弹出面板"
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }

        styles.listen { (name: String) in
            if name == "bottomButton" {
                for b in self.views { b.bottomButton = self.styles.bottomButton }
            } else if name == "titleBar" {
                for b in self.views { b.titleBar = self.styles.titleBar }
            } else if name == "content" {
                for b in self.views { b.content = self.styles.content }
            }
        }
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        panel.popUp(target: view)
    }
    
    func panelButtonClicked(_ panel: XHBPanel, _ btnId: XHBButton.ButtonId?) {
        XHBTipView.toast(panel, "点击了按钮 \(btnId ?? .Unknown)")
    }

    func panelDismissed(panel: XHBPanel) {
        if view.window != nil {
            XHBTipView.toast(view, "面板消失")
            view.addSubview(panel)
            panel.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview().offset(20)
                maker.trailing.equalToSuperview().offset(-20)
                maker.top.equalToSuperview().offset(20)
            }
        }
    }
}

