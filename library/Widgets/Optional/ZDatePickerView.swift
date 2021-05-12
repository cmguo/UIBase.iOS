//
//  ZDatePickerView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation

@objc public protocol ZDatePickerViewDelegate {
    @objc optional func datePickerSelectDateChanged(picker: ZDatePickerView, date: Date)
}

public class ZDatePickerView : UIDatePicker {
    
    public enum DateMode : Int, RawRepresentable, CaseIterable {
        case HourMinute
        case YearMonthDay
        case MonthWithDayWithWeekHourMinute
    }
    
    public var dateMode: DateMode {
        get { DateMode(rawValue: datePickerMode.rawValue)! }
        set { datePickerMode = Mode(rawValue: newValue.rawValue)! }
    }
    
    public var startDate: Date? {
        get { return minimumDate }
        set { minimumDate = newValue }
    }
    
    public var endDate: Date? {
        get { return maximumDate }
        set { maximumDate = newValue }
    }
    
    public var selectDate: Date {
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
    
    public var timeInterval: Int {
        get { minuteInterval }
        set { minuteInterval = newValue }
    }
    
    public var highlightsToday: Bool {
        get { return self.value(forKey: "highlightsToday") as! Bool }
        set { setValue(newValue, forKey: "highlightsToday") }
    }
    
    public var callback: ZDatePickerViewDelegate? = nil
    
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
        callback?.datePickerSelectDateChanged?(picker: self, date: date)
    }
    
}
