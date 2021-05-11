//
//  XHBActionSheetController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation
import UIBase

class XHBActionSheetController: ComponentController, XHBActionSheetCallback, XHBPanelCallbackDelegate {

    class Styles : ViewStyles {
        
        @objc static let _icon = ["图标", "附加在文字标题左侧的图标，资源ID类型，不能点击"]
        @objc static let _iconStyle = IconStyle(Styles.self, "icon")
        @objc var icon: URL? = nil

        @objc static let _title = ["标题", "标题文字，一般在中间显示"]
        @objc var title = "标题"

        @objc static let _subTitle = ["详细描述", "描述文字，显示在标题下面"]
        @objc var subTitle = "真的要撤回该作业吗？\n所有已提交的学生作业也会被删除！"

    }
    
    class Model : ViewModel {
        
        let states: [UIControl.State] = [.STATES_SELECTED]
        
        let buttons = ["删除内容", "列表标题"]
    }
    
    private let styles = Styles()
    private let model = Model()
    private let sheet = XHBActionSheet()
    private var views = [XHBActionSheet]()
    
    private let button = XHBButton()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue_100

        sheet.backgroundColor = .white
        sheet.title = styles.title
        sheet.subTitle = styles.subTitle
        sheet.buttons = model.buttons
        sheet.states = model.states
        sheet.callback = self
        view.addSubview(sheet)
        sheet.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        views.append(sheet)

        button.text = "弹出面板"
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }
        
        styles.listen { (name: String) in
            if name == "icon" {
                for b in self.views { b.icon = self.styles.icon }
            } else if name == "title" {
                for b in self.views { b.title = self.styles.title }
            } else if name == "subTitle" {
                for b in self.views { b.subTitle = self.styles.subTitle }
            }
        }
        
    }
    
    func onAction(sheet: XHBActionSheet, index: Int) {
        XHBTipView.toast(sheet, "点击了按钮 \(index)")
    }

    @objc func buttonClicked(_ sender: UIView) {
        let panel = XHBPanel()
        panel.bottomButton = "取消"
        sheet.removeFromSuperview()
        panel.content = sheet
        panel.delegate = self
        panel.popUp(target: view)
    }
    
    func panelDismissed(panel: XHBPanel) {
        panel.content = nil
        view.addSubview(sheet)
        sheet.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
            maker.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
    }
}

