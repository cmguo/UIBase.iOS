//
//  ZTimePickerViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation
import UIBase

class ZTimePickerViewController: ComponentController, ZTimePickerViewCallback, ZDatePickerViewCallback, ZPanelCallbackDelegate {

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
        
        @objc static let _timeInterval = ["时间间隔", "显示时间时，减少精度，如 interval = 5，则只显示 0、5、10 ..."]
        @objc var timeInterval = 0
        
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
    private let picker: UIView & TimePickerView
    private var views = [TimePickerView]()
    
    private let label = UILabel()
    private let text = UILabel()
    private let button = ZButton()
    
    init(_ component: Component) {
        picker = component is ZTimePickerViewComponent ? ZTimePickerView() : ZDatePickerView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        picker.startTime = styles.startTime
        picker.endTime = styles.endTime
        view.addSubview(picker)
        picker.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
            maker.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
        views.append(picker)
        picker.setCallback(self)

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
                for b in self.views { b.timeModeInt = self.styles.timeMode }
            } else if name == "startTime" {
                for b in self.views { b.startTime = self.styles.startTime }
            } else if name == "endTime" {
                for b in self.views { b.endTime = self.styles.endTime }
            } else if name == "selectTime" {
                for b in self.views { b.selectTime = self.styles.selectTime }
            } else if name == "timeInterval" {
                for b in self.views { b.timeInterval = self.styles.timeInterval }
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

protocol TimePickerView : AnyObject {
    var timeModeInt: Int { get set }
    var startTime: Date? { get set }
    var endTime: Date? { get set }
    var selectTime: Date { get set }
    var textAppearance: TextAppearance? { get set }
    var timeInterval: Int { get set }
    func setCallback(_ controller: ZTimePickerViewController)
}

extension ZTimePickerView : TimePickerView {
    var timeModeInt: Int {
        get { return timeMode.rawValue }
        set { timeMode = TimeMode(rawValue: newValue)! }
    }
    func setCallback(_ controller: ZTimePickerViewController) {
        callback = controller
    }
}

extension ZDatePickerView : TimePickerView {
    var timeModeInt: Int {
        get { return dateMode.rawValue }
        set { dateMode = DateMode(rawValue: newValue)! }
    }
    var startTime: Date? {
        get { startDate }
        set { startDate = newValue }
    }
    var endTime: Date? {
        get { endDate }
        set { endDate = newValue }
    }
    var selectTime: Date {
        get { selectDate }
        set { selectDate = newValue }
    }
    func setCallback(_ controller: ZTimePickerViewController) {
        callback = controller
    }
}
