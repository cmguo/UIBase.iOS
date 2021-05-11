//
//  XHBDialogController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/27.
//

import Foundation
import UIBase

class XHBDialogController: ComponentController, XHBDialogCallback {

    class Styles : ViewStyles {
        
        @objc static let _image = ["图片", "附加在顶部的图片"]
        @objc static let _imageStyle = ContentStyle(Styles.self, "image", ["image"])
        @objc var image: URL? = nil
        
        @objc static let _closeIconColor = ["关闭按钮颜色", "关闭按钮颜色，设置为透明色，则不显示"]
        @objc static let _closeIconColorStyle = ColorStyle(Styles.self, "closeIconColor")
        @objc var closeIconColor = UIColor.clear

        @objc static let _title = ["标题", "标题文字，一般在中间显示"]
        @objc var title = "标题"

        @objc static let _subTitle = ["详细描述", "描述文字，显示在标题下面"]
        @objc var subTitle = "真的要撤回该作业吗？\n所有已提交的学生作业也会被删除！"

        @objc static let _content = ["内容", "中间或者整体内容，UIView 实例"]
        @objc static let _contentStyle = ContentStyle(Styles.self, "content", ["@UIView"])
        @objc var content: Any? = nil

        @objc static let _data = ["数据", "通过 BindingAdapter 实现的虚拟属性，间接设置给扩展内容，仅用于基于 DataBinding 的布局"]
        @objc var data: Any? = nil

        @objc static let _cancelButton = ["取消按钮", "取消按钮的内容，参见按钮的 content 样式"]
        @objc static let _cancelButtonStyle = ContentStyle(Styles.self, "cancelButton", ["<button>"])
        @objc var cancelButton: Any? = "取消"

        @objc static let _confirmButton = ["确认按钮", "确认按钮的内容，参见按钮的 content 样式"]
        @objc static let _confirmButtonStyle = ContentStyle(Styles.self, "confirmButton", ["<button>"])
        @objc var confirmButton: Any? = "确认"
        
        @objc var moreButtons = false
        
        @objc static let _checkBoxText = ["底部复选框", "底部复选框，可选"]
        @objc var checkBoxText: String? = nil
    }
    
    class Model : ViewModel {
        let buttons = ["删除内容", "列表标题"]
     }
    
    private let styles = Styles()
    private let model = Model()
    private let dialog = XHBDialog()
    private var views = [XHBDialog]()
    
    private let button = XHBButton()


    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        dialog.title = styles.title
        dialog.subTitle = styles.subTitle
        dialog.cancelButton = styles.cancelButton
        dialog.confirmButton = styles.confirmButton
        dialog.callback = self
        view.addSubview(dialog)
        dialog.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
        }
        views.append(dialog)

        button.text = "弹出面板"
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }

        styles.listen { (name: String) in
            if name == "title" {
                for b in self.views { b.title = self.styles.title }
            } else if name == "image" {
                for b in self.views { b.image = self.styles.image }
            } else if name == "closeIconColor" {
                for b in self.views { b.closeIconColor = self.styles.closeIconColor }
            } else if name == "subTitle" {
                for b in self.views { b.subTitle = self.styles.subTitle }
            } else if name == "content" {
                for b in self.views { b.content = self.styles.content }
            } else if name == "cancelButton" {
                for b in self.views { b.cancelButton = self.styles.cancelButton }
            } else if name == "confirmButton" {
                for b in self.views { b.confirmButton = self.styles.confirmButton }
            } else if name == "checkBoxText" {
                for b in self.views { b.checkBoxText = self.styles.checkBoxText }
            } else if name == "moreButtons" {
                for b in self.views { b.moreButtons = self.styles.moreButtons ? self.model.buttons : [] }
            }
        }
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        dialog.popUp(target: view)
    }
    
    func dialogButtonClicked(dialog: XHBDialog, btnId: XHBButton.ButtonId?) {
        XHBTipView.toast(dialog, "点击了按钮 \(btnId ?? .Unknown)")
    }
    
    func dialogMoreButtonClicked(dialog: XHBDialog, index: Int) {
        XHBTipView.toast(dialog, "点击了按钮 \(index)")
    }
    
    func dialogDismissed(dialog: XHBDialog) {
        if view.window != nil {
            XHBTipView.toast(view, "面板消失")
            view.addSubview(dialog)
            dialog.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview().offset(20)
                maker.trailing.equalToSuperview().offset(-20)
                maker.top.equalToSuperview().offset(20)
            }
        }
    }
}

