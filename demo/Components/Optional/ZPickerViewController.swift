//
//  ZPickerViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation
import UIBase

class ZPickerViewController: ComponentController, ZPickerViewDelegate, ZPanelDelegate {

    class Styles : ViewStyles {
        
        @objc static let _singleSelection = ["单选", "单项选择，只可选择一个，也可能没有选择任何项"]
        @objc var singleSelection = false

    }
    
    class Model : ViewModel {
        
        let titles = [
            "不可选择的已选择项",
            "不可选择的未选择项",
            "普通选项",
            "普通选项",
            "普通选项",
            "过于长的选项过于长的选项过于长的选项…",
            "普通选项",
        ]
        
        let icons = Icons.iconURLs

        let states: [UIControl.State?] = [.STATES_DISABLED, .STATE_DISABLED]
        
        var selection: Int? = 0 {
            didSet {
                notify("selection")
            }
        }
        
        var selections: [Int] = [0] {
            didSet {
                notify("selections")
            }
        }
    }
    
    private let styles = Styles()
    private let model = Model()
    private let picker = ZPickerView()
    private var views = [ZPickerView]()
    
    private let label1 = UILabel()
    private let label2 = UILabel()
    private let text1 = UILabel()
    private let text2 = UILabel()
    private let button = ZButton()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.titles = model.titles
        picker.icons = model.icons
        picker.states = model.states
        picker.selections = model.selections
        picker.callback = self
        view.addSubview(picker)
        picker.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
        views.append(picker)

        button.text = "弹出面板"
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        label1.text = "选中项"
        label2.text = "选中项集合"
        text1.text = "0"
        text2.text = "[0]"
        view.addSubview(button)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(text1)
        view.addSubview(text2)
        label1.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.width.equalTo(100)
            maker.bottom.equalTo(label2.snp.top).offset(-10)
        }
        label2.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.width.equalTo(100)
            maker.bottom.equalTo(button.snp.top).offset(-20)
        }
        text1.snp.makeConstraints { (maker) in
            maker.top.equalTo(label1.snp.top)
            maker.leading.equalTo(label1.snp.trailing).offset(20)
            maker.trailing.equalToSuperview().offset(-20)
        }
        text2.snp.makeConstraints { (maker) in
            maker.top.equalTo(label2.snp.top)
            maker.leading.equalTo(label2.snp.trailing).offset(20)
            maker.trailing.equalToSuperview().offset(-20)
        }
        button.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }

        styles.listen { (name: String) in
            if name == "singleSelection" {
                for b in self.views { b.singleSelection = self.styles.singleSelection }
            }
        }
        
        model.listen { name in
            if name == "selection" {
                self.text1.text = self.model.selection?.description ?? ""
            } else if name == "selections" {
                self.text2.text = self.model.selections.description
           }
        }
    }
    
    func onSelectionChanged(picker: ZPickerView, selection: Int) {
        model.selection = selection >= 0 ? selection : nil
    }
    
    func onSelectionsChanged(picker: ZPickerView, selections: [Int]) {
        model.selections = selections
    }

    @objc func buttonClicked(_ sender: UIView) {
        let panel = ZPanel()
        panel.titleBar = ContentStyle.Contents["title_icon"]
        picker.removeFromSuperview()
        panel.content = picker
        panel.delegate = self
        panel.popUp(target: view)
    }
    
    func panelDismissed(panel: ZPanel) {
        panel.content = nil
        view.addSubview(picker)
        picker.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
            maker.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
    }
}

