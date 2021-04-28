//
//  ZTimePickerViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation
import UIBase


class ZTimePickerViewController: ComponentController, ZTimePickerViewCallback, ZPanelCallbackDelegate {

    class Styles : ViewStyles {
        
        @objc static let _timeMode = ["时间模式", "时间模式枚举"]
        @objc static let _timeModeStyle: NSObject = EnumStyle(Styles.self, "timeMode", ZTimePickerView.TimeMode.self)
        @objc var timeMode: Int = 0
        
        @objc static let _startTime = ["开始时间", "开始时间"]
        @objc static let _startTimeStyle = TimeStyle(Styles.self, "startTime")
        @objc var startTime: Date? = nil
        
        @objc static let _endTime = ["结束时间", "结束时间"]
        @objc static let _endTimeStyle = TimeStyle(Styles.self, "endTime")
        @objc var endTime: Date? = nil

        @objc static let _selectTime = ["选中时间", "当前选中时间"]
        @objc static let _selectTimeStyle = TimeStyle(Styles.self, "selectTime")
        @objc var selectTime: Date = Date()
        
        var timeMode2: ZTimePickerView.TimeMode {
            return ZTimePickerView.TimeMode(rawValue: timeMode)!
        }
        
        override init() {
            startTime = selectTime.addingTimeInterval(-10 * 24 * 3600)
            endTime = selectTime.addingTimeInterval(10 * 24 * 3600)
        }
    }
    
    class Model : ViewModel {}
    
    private let styles = Styles()
    private let model = Model()
    private let picker = ZTimePickerView()
    private var views = [ZTimePickerView]()
    
    private let label = UILabel()
    private let text = UILabel()
    private let button = ZButton()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        picker.startTime = styles.startTime
        picker.endTime = styles.endTime
        picker.callback = self
        view.addSubview(picker)
        picker.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
            maker.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
        views.append(picker)

        button.text = "弹出面板"
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        label.text = "选中时间"
        text.text = "0"
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(text)
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.bottom.equalTo(button.snp.top).offset(-10)
        }
        text.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.top)
            maker.leading.equalTo(label.snp.trailing).offset(20)
            maker.trailing.equalToSuperview().offset(-20)
        }
        button.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }

        styles.listen { (name: String) in
            if name == "timeMode" {
                for b in self.views { b.timeMode = self.styles.timeMode2 }
            } else if name == "startTime" {
                for b in self.views { b.startTime = self.styles.startTime }
            } else if name == "endTime" {
                for b in self.views { b.endTime = self.styles.endTime }
            } else if name == "selectTime" {
                for b in self.views { b.selectTime = self.styles.selectTime }
            }
        }
    }
    
    func timePickerSelectTimeChanged(picker: ZTimePickerView, time: Date) {
        styles.selectTime = time
        text.text = Styles._selectTimeStyle.get(on: styles)
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

