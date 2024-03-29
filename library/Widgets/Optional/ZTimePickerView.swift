//
//  ZTimePickerView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation

@objc public protocol ZTimePickerViewDelegate {
    @objc optional func timePickerSelectTimeChanged(picker: ZTimePickerView, time: Date)
}

public class ZTimePickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public enum TimeMode : Int, RawRepresentable, CaseIterable {
        case YearMonthDay = 0b110100000
        case YearMonthWithDayWithWeek = 0b1110010000
        case MonthWithDayWithWeekHourMinute = 0b1010010110
        case HourMinute = 0b0000000110
    }
    
    public var timeMode: TimeMode = .YearMonthDay {
        didSet {
            syncTimeMode()
        }
    }
    
    public var timeMode2: Int = 0 {
        didSet {
            syncTimeMode()
        }
    }
    
    public var labels: [String] = [
        "%02d秒", "%02d分", "%02d时", "上午/下午",
        "%02d日 周x", "第%d周", "%02d月", "%04d年"]
    
    public var startTime: Date? = nil {
        didSet {
            syncTimeRange()
        }
    }
    
    public var endTime: Date? = nil {
        didSet {
            syncTimeRange()
        }
    }
    
    public var selectTime: Date {
        get { state.current! }
        set {
            state.setCurrent(newValue)
        }
    }

    public var textAppearance: TextAppearance? = nil {
        didSet {
            if let ta = textAppearance {
                setValue(ta.textColor, forKey: "textColor")
            }
        }
    }
    
    public var timeInterval: Int = 1 {
        didSet {
            if oldValue != timeInterval {
                state.setInterval(timeInterval)
            }
        }
    }
    
    public var timeDelegate: ZTimePickerViewDelegate? = nil
    
    fileprivate let state = CalendarState()
    
    private let _style: ZTimePickerViewStyle
        
    public init(style: ZTimePickerViewStyle = .init()) {
        _style = style
        textAppearance = style.textAppearance
        super.init(frame: .zero)
        self.state.fieldUpdated = { f in
            self.reloadComponent(f.index)
            self.selectRow(self.state.getCurrent(f.index), inComponent: f.index, animated: false)
        }
        self.dataSource = self
        self.delegate = self
        syncTimeMode()
        self.state.setCurrent(selectTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* private */
    
    private func syncTimeMode() {
        let mode = timeMode2 == 0 ? timeMode.rawValue : timeMode2
        state.setMode(mode >> 4, mode & 15, labels, timeInterval)
        reloadAllComponents()
        for i in 0..<state.fields.count {
            self.selectRow(self.state.getCurrent(i), inComponent: i, animated: false)
        }
        setNeedsLayout()
    }
    
    private func syncTimeRange() {
        state.setRange(startTime, endTime)
    }
    
    private func syncTime() {
        state.setCurrent(selectTime)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        timeDelegate?.timePickerSelectTimeChanged?(picker: self, time: selectTime)
    }
 
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return state.fields.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return state.fields[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // TODO: update on reloadComponent
        return state.getMaxTitle(component).boundingSize(font: textAppearance!.font).width + 10
    }
    
//    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return state.getCurrent(component).boundingSize(font: textAppearance!.font).height
//    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state.setCurrent(component, row)
        timeDelegate?.timePickerSelectTimeChanged?(picker: self, time: selectTime)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        state.title(component, row)
    }
}
