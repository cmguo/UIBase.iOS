//
//  CalendarState.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/29.
//

import Foundation

class CalendarState {
    
    static let MAX_DATE = Date(timeIntervalSince1970: 7258118400) // 2200/1/1
    static let MIN_DATE = Date(timeIntervalSince1970: 0)

    enum Field : Int, RawRepresentable, Comparable {
        
        public static let allCases: [Calendar.Component] = [
            .era, .year, .month, .day,
            .hour, .minute, .second,
            .weekday, .weekdayOrdinal, .quarter,
            .weekOfMonth, .weekOfYear, .yearForWeekOfYear,
        ]

        static func < (lhs: Field, rhs: Field) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        func comp() -> Calendar.Component {
            switch self {
            case .DAY_OF_YEAR:
                return .day
            default:
                return Self.allCases[self.rawValue]
            }
        }
        
        func ofComp() -> Calendar.Component? {
            switch self {
            case .MONTH_OF_YEAR, .WEEK_OF_YEAR, .DAY_OF_YEAR:
                return Self.YEAR.comp()
            case .DAY_OF_MONTH, .WEEK_OF_MONTH:
                return Self.MONTH_OF_YEAR.comp()
            default:
                return nil
            }
        }
        
        case YEAR = 1
        case MONTH = 16 // ALL MONTH
        case MONTH_OF_YEAR = 2
        case WEEK = 17 // ALL WEEK
        case WEEK_OF_YEAR = 11
        case WEEK_OF_MONTH = 10
        case DAY = 18 // ALL DAY
        case DAY_OF_MONTH = 3
        case DAY_OF_WEEK = 7
        case DAY_OF_YEAR = 19
        case AM_PM = 20
        case HOUR = 21 // 12 hours
        case HOUR_OF_DAY = 4  // 24 hours
        case MINUTE = 5
        case SECOND = 6
    }

    var start: Date = MIN_DATE
    
    var end: Date = MAX_DATE
    
    var current: Date? = Date()
    
    var calendar: Calendar = .current
    
    var isLunar = false
    
    var fieldUpdated: (FieldState) -> Void = { _ in }

    typealias Formatter = (_ state:  CalendarState, _ date : Date) -> String
    
    class FieldState {
        var index: Int
        var field: Field
        var format: Formatter = { _, _ in "" }
        var minMax: (Int, Int) = (0, 0)
        var interval = 1
        
        var count: Int {
            let min = (minMax.0 + interval - 1) / interval
            let max = minMax.1 / interval
            return max - min + 1
        }
        
        init(_ index: Int, _ field: Field) {
            self.index = index
            self.field = field
        }

        subscript(index: Int) -> Int {
            let min = (minMax.0 + interval - 1) / interval
            return (min + index) * interval
        }
        
        func indexOf(_ value: Int) -> Int {
            let min = (minMax.0 + interval - 1) / interval
            // will return -1 if current < next interval
            return value / interval - min
        }
    }
    
    var fields: [FieldState] = [] {
        didSet {
            for f in fields {
                f.minMax = getMinMax(f.field)
            }
        }
    }
    
    func setRange(_ startDate: Date?, _ endDate: Date?) {
        start = startDate ?? Self.MIN_DATE
        end = endDate ?? Self.MAX_DATE
        if let cur = current {
            var c = cur
            if c < start {
                c = Date(copy: start)
            } else if end < c {
                c = Date(copy: end)
            }
            current = nil
            setCurrent(c)
        }
    }

    func setCurrent(_ date: Date) {
        var diff = false
        var date = date
        if date < start {
            date = start
        } else if date > end {
            date = end
        }
        if (current == nil) {
            current = Date(copy: date)
            diff = true
        }
        for f in fields {
            if !diff {
                if get(date, f.field) == get(current!, f.field) {
                    continue
                }
                current = date
                diff = true
            }
            f.minMax = getMinMax(f.field)
            fieldUpdated(f)
        }
    }
    
    func setInterval(_ interval: Int) {
        guard let f = fields.last else { return }
        if f.field == .SECOND || f.field == .MINUTE || f.field == .HOUR || f.field == .HOUR_OF_DAY {
            f.interval = interval
            fieldUpdated(f)
        }
    }
    
    func setMode(_ dateMode: Int, _ timeMode: Int, _ labels: [String], _ interval: Int) {
        
        let MODE_DAY_IN_WEEK = 1
        let MODE_DAY_IN_MONTH = 2
        let MODE_WEEK = 4
        let MODE_MONTH = 8
        let MODE_YEAR = 16
        let MODE_COMBINE = 32
        //let MODE_SECOND = 1
        //let MODE_MINUTE = 2
        let MODE_HOUR = 4
        let MODE_AMPM = 8

        var fields: [CalendarState.Field?] = [
            .SECOND,
            .MINUTE,
            .HOUR_OF_DAY,
            .AM_PM,
            nil, nil, nil, nil]
        
        var formatters: [CalendarState.Formatter?] = Array(repeating: nil, count: 8)

        // time is simple
        for ti in 0..<4 {
            if (timeMode & (1 << ti) == 0) {
                fields[ti] = nil
            } else {
                formatters[ti] = Self.formatter(fields[ti]!, labels[ti])
            }
        }
        if timeMode & (MODE_AMPM | MODE_HOUR) == MODE_AMPM | MODE_HOUR {
            fields[2] = .HOUR
        }
        if fields[3] != nil {
            let t = labels[3].split(separator: "/")
            formatters[3] = { state, date in
                let n = state.get(date, .AM_PM)
                return t[n].description
            }
        }
        // date
        // ignore week for lunar
        let mode = MODE_DAY_IN_WEEK | MODE_DAY_IN_MONTH
        let day = dateMode & mode
        let monwk = (dateMode & (MODE_WEEK | MODE_MONTH)) >> 2
        let day2 = monwk == 0 ? day : (day & monwk)
        let dayFm = day | monwk
        // first char is day mode ( of week | month )
        // second char is additional label
        // + is same as additional char, but day2 == 0
        // int combine mode ( diff only day == 0)
        //
        //    day   0   1   2   3
        // monwk
        //  0           W   M   WM
        //  1     [Y    W   W+  WM
        //  2     [Y    M+  M   MW
        //  3     [M    WM  W   WM
        let dateMode2 = ((dateMode >> 1) & 0b11110) | (day2 == 0 ? 0 : 1)
        if (dateMode & MODE_COMBINE == 0) {
            var lastField = -1
            for i in 0..<4 {
                if (dateMode2 & (1 << i) != 0) {
                    lastField = i + 4
                }
                if (lastField >= 0) {
                    fields[lastField] = Self.allFields[lastField - 4][i + 4 - lastField]
                    //Log.d(TAG, "syncMode fields[" + lastField + "]=" + fields[lastField].toString())
                }
            }
        } else {
            //print(TAG, "syncMode combine $dateMode2")
            var curFields = 0
            var indexField = 0
            var indexMode = -1
            for i in 0..<5 {
                if (dateMode2 & (1 << i) == 0) {
                    indexField += 1
                } else {
                    if (indexMode >= 0) {
                        fields[indexMode + 4] = Self.allFields[curFields][indexField]
                        //Log.d(TAG, "syncMode fields[" + (indexMode + 4) + "]=" + fields[indexMode + 4].toString())
                        curFields += indexField + 1
                        indexField = 0
                    }
                    indexMode = i
                }
            }
        }
        // day
        formatters[4] = Self.dayFormatter(dayFm, labels[4])
        // week
        if fields[6] == nil {
            formatters[5] = Self.formatter(.WEEK_OF_YEAR, labels[5])
        } else {
            formatters[5] = Self.formatter(.WEEK_OF_MONTH, labels[5])
        }
        // month
        formatters[6] = Self.formatter(.MONTH_OF_YEAR, labels[6])
        // year
        if (dateMode & MODE_YEAR) != 0 {
            fields[7] = .YEAR
            formatters[7] = Self.formatter(.YEAR, labels[7])
        }
        // handle combine
        if dateMode & MODE_COMBINE != 0 {
            if day2 == 0 {
                // merge day to parent
                if fields[5] != nil {
                    formatters[5] = Self.joinFormatter(formatters[5]!, formatters[4]!)
                } else if fields[6] != nil {
                    formatters[6] = Self.joinFormatter(formatters[6]!, formatters[4]!)
                }
            }
            if (monwk == 0) {
                // merge month | week to year
                var i = 4 // assert(fields[4] != nil)
                if (fields[6] != nil) {
                    i = 6
                } else if (fields[5] != nil) {
                    i = 5
                }
                if (fields[7] != nil) {
                    formatters[7] = Self.joinFormatter(formatters[7]!, formatters[i]!)
                }
            }
        }
        // bindAdapter
        var last = 8
        var fieldStates: [CalendarState.FieldState] = []
        for i in stride(from: 7, through: 0, by: -1) {
            if let f = fields[i] {
                let state = CalendarState.FieldState(fieldStates.count, f)
                state.format = formatters[i]!
                state.minMax = getMinMax(f)
                fieldStates.append(state)
                last = i
            }
        }
        if (last < 3) {
            fieldStates.last?.interval = interval
        }
        
        self.fields = fieldStates
    }
    
    func setCurrent(_ field: Int, _ index: Int) {
        guard let current = current else {
            return
        }
        let f = fields[field]
        let cur = get(current, f.field)
        let date = add(current, f.field, f[index] - cur)
        setCurrent(date)
    }
    
    func getCurrent(_ field: Int) -> Int {
        guard let current = current else {
            return -1
        }
        let f = fields[field]
        let cur = get(current, f.field)
        return f.indexOf(cur)
    }
    
    func getMaxTitle(_ field: Int) -> String {
        return title(field, fields[field].minMax.1 - fields[field].minMax.0)
    }

    func title(_ field: Int, _ index: Int) -> String {
        guard let current = current else {
            return ""
        }
        let f = fields[field]
        let cur = get(current, f.field)
        let date = add(current, f.field, f[index] - cur)
        return f.format(self, date)
    }
    
    private static let MS_IN_DAY: Double = 24 * 3600;

    func getMinMax(_ field: Field) -> (Int, Int) {
        guard let current = current else {
            return (0, 0)
        }
        switch field {
        case .YEAR:
            return (get(start, field), get(end, field))
        case .MONTH, .WEEK, .DAY:
            return (0, get(end, field))
        default:
            break
        }
        let cur = self[field]
        let range: Range<Int>
        if let of = field.ofComp() {
            range = calendar.range(of: field.comp(), in: of, for: current)!
        } else {
            range = calendar.maximumRange(of: field.comp())!
        }
        var min = range.lowerBound
        var max = range.upperBound - 1
        let d1 = add(current, field, min - cur)
        if d1 < start {
            min = get(start, field)
        }
        let d2 = add(current, field, max - cur)
        if end < d2 {
            max = get(end, field)
        }
        return (min, max)
    }

    func add(_ date: Date, _ field: Field, _ i: Int) -> Date {
        switch field {
        case .MONTH:
            return add(date, .MONTH_OF_YEAR, i)
        case .WEEK, .DAY:
            var i = i
            if field == .WEEK { i *= 7 }
            return add(date, .DAY_OF_YEAR, i)
        case .DAY_OF_YEAR: // TODO:
            return calendar.date(byAdding: field.comp(), value: i, to: date, wrappingComponents: false)!
        default:
            return calendar.date(byAdding: field.comp(), value: i, to: date, wrappingComponents: true)!
        }
    }

    subscript(field: Field) -> Int {
        return get(current!, field)
    }

    func get(_ date: Date, _ field: Field) -> Int {
        switch field {
        case .MONTH:
            let s = get(start, .MONTH_OF_YEAR) + get(start, .YEAR) * 12
            let e = get(end, .MONTH_OF_YEAR) + get(end, .YEAR) * 12
            return e - s
        case .WEEK, .DAY:
            var days = date.timeIntervalSince(calendar.startOfDay(for: start))
            days = days / Self.MS_IN_DAY
            return Int(field == .WEEK ? (days / 7) : days)
        default:
            if let of = field.ofComp() {
                return calendar.ordinality(of: field.comp(), in: of, for: date)!
            } else {
                return calendar.component(field.comp(), from: date)
            }
        }
    }

    func getNormal(_ date: Date, _ field: Field) -> Int {
        var field = field
        if field == .MONTH {
            field = .MONTH_OF_YEAR
        } else if field == .WEEK {
            field = .WEEK_OF_YEAR
        } else if field == .DAY {
            field = .DAY_OF_YEAR
        }
        return get(date, field)
    }

    private static let allFields: [[Field]] = [[
        .DAY_OF_WEEK, .DAY_OF_MONTH, .DAY_OF_YEAR, .DAY
    ], [
        .WEEK_OF_MONTH, .WEEK_OF_YEAR, .WEEK
    ], [
        .MONTH_OF_YEAR, .MONTH
    ], [
        .YEAR
    ]]

    private static func joinFormatter(_ formatter: @escaping CalendarState.Formatter, _ formatter1: @escaping CalendarState.Formatter) -> CalendarState.Formatter {
        return { state, date in formatter(state, date) + " " + formatter1(state, date) }
    }

    private static let weekNum = ["日", "一", "二", "三", "四", "五", "六"]

    private static func dayFormatter(_ dayFm: Int, _ label: String) -> CalendarState.Formatter {
        let t = label.split(separator: " ")
        return { state, date in
            var r = ""
            if dayFm & 2 != 0 {
                let dm = state.get(date, .DAY_OF_MONTH)
                r += t[0].replacingOccurrences(of: "x", with: dm.description)
            }
            if dayFm == 3 {
                r += " "
            }
            if dayFm & 1 != 0 {
                let dw = state.get(date, .DAY_OF_WEEK)
                r += t[1].replacingOccurrences(of: "x", with: Self.weekNum[dw - 1])
            }
            return r
        }
    }

    private static func formatter(_ field: CalendarState.Field, _ label: String) -> CalendarState.Formatter {
        return { state, date in
            let dm = state.get(date, field)
            return label.replacingOccurrences(of: "x", with: dm.description)
        }
    }

}
extension Date {
    init(copy: Date) {
        self.init(timeIntervalSince1970: copy.timeIntervalSince1970)
    }
}

