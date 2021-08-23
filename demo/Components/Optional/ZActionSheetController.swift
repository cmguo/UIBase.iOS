//
//  ZActionSheetController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/25.
//

import Foundation
import UIBase

class ZActionSheetController: ComponentController, ZActionSheetDelegate, ZPanelDelegate {

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
        
        let states: [UIControl.State] = [.selected]
        
        let buttons = ["删除内容", "项目1", "项目2"]
    }
    
    private let styles = Styles()
    private let model = Model()
    private let sheet = ZActionSheet()
    private var views = [ZActionSheet]()
    
    private let button = ZButton()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue_100

        sheet.backgroundColor = .bluegrey_00
        sheet.title = styles.title
        sheet.subTitle = styles.subTitle
        sheet.buttons = model.buttons
        sheet.states = model.states
        sheet.delegate = self
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
                for b in self.views { b.title = self.styles.title.isEmpty ? nil : self.styles.title }
            } else if name == "subTitle" {
                for b in self.views { b.subTitle = self.styles.subTitle.isEmpty ? nil : self.styles.subTitle }
            }
        }
        
    }
    
    func onAction(sheet: ZActionSheet, index: Int) {
        ZTipView.toast(sheet, "点击了按钮 \(index)")
    }

    @objc func buttonClicked(_ sender: UIView) {
        let panel = ZPanel()
        panel.bottomButton = "取消"
        sheet.removeFromSuperview()
        panel.content = sheet
        panel.delegate = self
        panel.popUp(target: view)
    }
    
    func panelDismissed(panel: ZPanel) {
        panel.content = nil
        view.addSubview(sheet)
        sheet.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
}

