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
        @objc var timeMode: Int = ZTimePickerView.TimeMode.YearMonthDay.rawValue
        
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
        @objc var timeInterval = 1
        
        @objc static let _timeMode2 = ["日历模式2", "通用日历模式，由 6 + 4 个 bit 位描述，从高到低依次是：合并模式、年、月、周次、日、周，上下午，时、分、秒"]
        @objc var timeMode2 = 0

        @objc static let _timeModeBit9 = ["合并", "通用日历模式第 10 个 bit 位，表示是否使用合并模式"]
        @objc var timeModeBit9 = false

        @objc static let _timeModeBit8 = ["年", "通用日历模式第 9 个 bit 位，表示是否显示年"]
        @objc var timeModeBit8 = false

        @objc static let _timeModeBit7 = ["月", "通用日历模式第 8 个 bit 位，表示是否显示月"]
        @objc var timeModeBit7 = false

        @objc static let _timeModeBit6 = ["周次", "通用日历模式第 7 个 bit 位，表示是否显示周次；如果显示月，则为当月的周次，否则为当年的周次"]
        @objc var timeModeBit6 = false

        @objc static let _timeModeBit5 = ["日", "通用日历模式第 6 个 bit 位，表示是否显示日"]
        @objc var timeModeBit5 = false

        @objc static let _timeModeBit4 = ["周", "通用日历模式第 5 个 bit 位，表示是否显示周"]
        @objc var timeModeBit4 = false

        @objc static let _timeModeBit3 = ["上下午", "通用日历模式第 4 个 bit 位，表示是否显示上午、下午"]
        @objc var timeModeBit3 = false

        @objc static let _timeModeBit2 = ["小时", "通用日历模式第 3 个 bit 位，表示是否显示小时"]
        @objc var timeModeBit2 = false

        @objc static let _timeModeBit1 = ["分钟", "通用日历模式第 2 个 bit 位，表示是否显示分钟"]
        @objc var timeModeBit1 = false

        @objc static let _timeModeBit0 = ["秒", "通用日历模式第 1 个 bit 位，表示是否显示秒"]
        @objc var timeModeBit0 = false

        override init() {
            startTime = selectTime.addingTimeInterval(-10 * 24 * 3600)
            endTime = selectTime.addingTimeInterval(10 * 24 * 3600)
        }
        
        override func notify(_ name: String) {
            if name.starts(with: "timeModeBit") {
                let index = name.replacingOccurrences(of: "timeModeBit", with: "").description
                let i = Int(index)!
                timeMode2 = timeMode2 ^ (1 << i)
                notify("timeMode2")
                return
            }
            super.notify(name)
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
            } else if name == "timeMode2" {
                for b in self.views { b.timeMode2 = self.styles.timeMode2 }
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
    var timeMode2: Int { get set }
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
        set {
            switch newValue {
            case ZTimePickerView.TimeMode.YearMonthDay.rawValue:
                dateMode = .YearMonthDay
            case ZTimePickerView.TimeMode.YearMonthWithDayWithWeek.rawValue:
                dateMode = .MonthWithDayWithWeekHourMinute
            default:
                dateMode = .HourMinute
            }
        }
    }
    var timeMode2: Int {
        get { return 0 }
        set {}
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
