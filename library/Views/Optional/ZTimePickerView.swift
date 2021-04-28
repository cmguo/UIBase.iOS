//
//  ZTimePickerView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation

@objc public protocol ZTimePickerViewCallback {
    @objc optional func timePickerSelectTimeChanged(picker: ZTimePickerView, time: Date)
}

public class ZTimePickerView : UIDatePicker {
    
    public enum TimeMode : Int, RawRepresentable, CaseIterable {
        case HourMinute
        case YearMonthDay
        case MonthWithDayWithWeekHourMinute
    }
    
    public var timeMode: TimeMode {
        get { TimeMode(rawValue: datePickerMode.rawValue)! }
        set { datePickerMode = Mode(rawValue: newValue.rawValue)! }
    }
    
    public var startTime: Date? {
        get { return minimumDate }
        set { minimumDate = newValue }
    }
    
    public var endTime: Date? {
        get { return maximumDate }
        set { maximumDate = newValue }
    }
    
    public var selectTime: Date {
        get { return date }
        set { date = newValue }
    }

    public var textAppearance: TextAppearance? = nil {
        didSet {
            if let ta = textAppearance {
                setValue(ta.textColor, forKey: "textColor")
            }
        }
    }
    
    public var highlightsToday: Bool {
        get { return self.value(forKey: "highlightsToday") as! Bool }
        set { setValue(newValue, forKey: "highlightsToday") }
    }
    
    public var callback: ZTimePickerViewCallback? = nil
    
    public init() {
        super.init(frame: .zero)
        locale = Locale(identifier: "zh_CN")
        calendar = .current
        if #available(iOS 13.4, *) {
            preferredDatePickerStyle = .wheels
        }
        addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    /* private */
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        callback?.timePickerSelectTimeChanged?(picker: self, time: date)
    }
    
}
