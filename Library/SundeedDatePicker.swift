//
//  SundeedDatePickerView.swift
//  SundeedDatePicker
//
//  Created by Nour Sandid on 6/20/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class SundeedDatePicker: UIPickerView {
    public enum Display {
        case year(format: String, size: CGFloat? = nil)
        case month(format: String, size: CGFloat? = nil)
        case day(format: String, size: CGFloat? = nil)
        case hour24(size: CGFloat? = nil)
        case hour12(size: CGFloat? = nil)
        case ampm(size: CGFloat? = nil)
        case minute(size: CGFloat? = nil)
        case second(size: CGFloat? = nil)
        case fullDate(format: String, size: CGFloat? = nil)
        
        func numberOfRows(for date: Date) -> Int {
            switch self {
            case .second:
                return 60
            case .minute:
                return 60
            case .hour12:
                return 12
            case .hour24:
                return 24
            case .ampm:
                return 2
            case .day:
                return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 31
            case .month:
                return 12
            case .year:
                return 9999
            case .fullDate:
                return 9999999
            }
        }
        
        var includeIndexAt0: Bool {
            switch self {
            case .second, .minute, .hour24, .fullDate, .ampm:
                return true
            case .day, .month, .year, .hour12:
                return false
            }
        }
        
        var displayFormat: String {
            switch self {
            case .second:
                return "ss"
            case .minute:
                return "mm"
            case .hour12:
                return "hh"
            case .hour24:
                return "HH"
            case .ampm:
                return "a"
            case .day(let format, _):
                return format
            case .month(let format, _):
                return format
            case .year(let format, _):
                return format
            case .fullDate(let format, _):
                return format
            }
        }
        
        var rowFormat: String {
            switch self {
            case .second:
                return "ss"
            case .minute:
                return "mm"
            case .hour12:
                return "hh"
            case .hour24:
                return "HH"
            case .ampm:
                return "a"
            case .day:
                return "dd"
            case .month:
                return "MM"
            case .year:
                return "yyyy"
            case .fullDate:
                return "dd MM yyyy"
            }
        }
        var rowWidth: CGFloat? {
            switch self {
            case .second(let width):
                return width
            case .minute(let width):
                return width
            case .hour12(let width):
                return width
            case .hour24(let width):
                return width
            case .ampm(let width):
                return width
            case .day(_, let width):
                return width
            case .month(_, let width):
                return width
            case .year(_, let width):
                return width
            case .fullDate(_, let width):
                return width
            }
        }
        var granularity: Calendar.Component {
            switch self {
            case .second:
                return .second
            case .minute:
                return .minute
            case .hour12:
                return .hour
            case .hour24:
                return .hour
            case .ampm:
                return .hour
            case .day:
                return .day
            case .month:
                return .month
            case .year:
                return .year
            case .fullDate:
                return .day
            }
        }
    }
    
    private var formatter: DateFormatter = DateFormatter()
    
    var dateChanged: ((Date?)->Void)?
    var date: Date? {
        didSet {
            reloadPicker()
            dateChanged?(date)
        }
    }
    var minimum: Date? {
        didSet {
            reloadPicker()
        }
    }
    var maximum: Date? {
        didSet {
            reloadPicker()
        }
    }
    
    var display: [Display] = [] {
        didSet {
            reloadPicker()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        dataSource = self
        delegate = self
    }
    
    func reloadPicker() {
        reloadAllComponents()
        scrollToSelectedDate()
    }
    
    func scrollToSelectedDate() {
        guard let date = date else { return }
        for component in 0..<display.count {
            let display = self.display[component]
            let rowFormat = display.rowFormat
            formatter.dateFormat = rowFormat
            if case .fullDate = display {
                formatter.dateFormat = display.rowFormat
                let firstDate = formatter.date(from: "01 01 0001")
                let row = Calendar.current.dateComponents([.day], from: firstDate!, to: date).day ?? 0
                selectRow(display.includeIndexAt0 ? row : row-1,
                          inComponent: component,
                          animated: true)
            } else if case .ampm = display {
                formatter.dateFormat = display.rowFormat
                let row = formatter.string(from: date).contains("A") ? 0 : 1
                selectRow(row,
                          inComponent: component,
                          animated: true)
            } else if var row = Int(formatter.string(from: date)),
                ((display.includeIndexAt0 && row-1 >= 0) || (!display.includeIndexAt0 && row > 0)) {
                if case .hour12 = display {
                    row %= 13
                }
                selectRow(display.includeIndexAt0 ? row : row-1, inComponent: component, animated: true)
            } else {
                reloadAllComponents()
            }
        }
    }
    
    func getDateByComponents(_ date: Date, display: Display) -> Date {
        guard let mainDate = self.date else { return Date()}
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let mainDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: mainDate)
        var components = DateComponents()
        switch display {
        case .second:
            components.year = mainDateComponents.year
            components.month = mainDateComponents.month
            components.day = mainDateComponents.day
            components.hour = mainDateComponents.hour
            components.minute = mainDateComponents.minute
            components.second = dateComponents.second
        case .minute:
            components.year = mainDateComponents.year
            components.month = mainDateComponents.month
            components.day = mainDateComponents.day
            components.hour = mainDateComponents.hour
            components.minute = dateComponents.minute
            components.second = mainDateComponents.second
        case .hour12:
            var isAM: Bool = false
            for index in 0..<self.display.count {
                let selected = selectedRow(inComponent: index)
                let display = self.display[index]
                if case .ampm = display {
                    let row = display.includeIndexAt0 ? selected : selected+1
                    isAM = row == 0
                }
            }
            components.year = mainDateComponents.year
            components.month = mainDateComponents.month
            components.day = mainDateComponents.day
            components.hour = isAM ? dateComponents.hour : (dateComponents.hour ?? 0) + 12
            components.minute = mainDateComponents.minute
            components.second = mainDateComponents.second
        case .hour24, .ampm:
            components.year = mainDateComponents.year
            components.month = mainDateComponents.month
            components.day = mainDateComponents.day
            components.hour = dateComponents.hour
            components.minute = mainDateComponents.minute
            components.second = mainDateComponents.second
        case .day:
            components.year = mainDateComponents.year
            components.month = mainDateComponents.month
            components.day = dateComponents.day
            components.hour = mainDateComponents.hour
            components.minute = mainDateComponents.minute
            components.second = mainDateComponents.second
        case .month:
            components.year = mainDateComponents.year
            components.month = dateComponents.month
            components.day = mainDateComponents.day
            components.hour = mainDateComponents.hour
            components.minute = mainDateComponents.minute
            components.second = mainDateComponents.second
        case .year:
            components.year = dateComponents.year
            components.month = mainDateComponents.month
            components.day = mainDateComponents.day
            components.hour = mainDateComponents.hour
            components.minute = mainDateComponents.minute
            components.second = mainDateComponents.second
        case .fullDate:
            components.year = dateComponents.year
            components.month = dateComponents.month
            components.day = dateComponents.day
            components.hour = dateComponents.hour
            components.minute = dateComponents.minute
            components.second = dateComponents.second
        }
        return calendar.date(from: components) ?? Date()
    }
    
    func dateIsEnabled(_ date: Date, display: Display) -> Bool {
        let date = getDateByComponents(date, display: display)
        let calendar = Calendar.current
        if let minimum = self.minimum, calendar.compare(date, to: minimum, toGranularity: display.granularity) == .orderedAscending {
            return false
        }
        if let maximum = self.maximum, calendar.compare(date, to: maximum, toGranularity: display.granularity) == .orderedDescending {
            return false
        }
        return true
    }
}

extension SundeedDatePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { display.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        formatter.dateFormat = "dd MM yyyy"
        return display[component].numberOfRows(for: self.date ?? formatter.date(from: "01 01 2000")!)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let display = self.display[component]
        let rowFormat = display.rowFormat
        let displayFormat = display.displayFormat
        formatter.dateFormat = rowFormat
        if case .fullDate = display {
            formatter.dateFormat = display.rowFormat
            let date = Calendar.current.date(byAdding: .day,
                                             value: row,
                                             to: formatter.date(from: "01 01 0001") ?? Date()) ?? Date()
            formatter.dateFormat = displayFormat
            let color: UIColor = dateIsEnabled(date, display: display) ? .darkText : .lightGray
            return NSAttributedString(string: formatter.string(from: date), attributes: [.foregroundColor: color])
        } else if case .ampm = display {
            return NSAttributedString(string: row == 0 ? "AM" : "PM")
        } else if let date = formatter.date(from: "\(display.includeIndexAt0 ? row : row+1)") {
            formatter.dateFormat = displayFormat
            let color: UIColor = dateIsEnabled(date, display: display) ? .darkText : .lightGray
            return NSAttributedString(string: formatter.string(from: date), attributes: [.foregroundColor: color])
        }
        return NSAttributedString(string: "---")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateString = ""
        var format = ""
        for index in 0..<display.count {
            let selectedRow = pickerView.selectedRow(inComponent: index)
            let display = self.display[index]
            let rowFormat = display.rowFormat
            formatter.dateFormat = rowFormat
            format.append("\(rowFormat) ")
            if case .fullDate = display {
                formatter.dateFormat = display.rowFormat
                let date = Calendar.current.date(byAdding: .day,
                                                 value: pickerView.selectedRow(inComponent: index),
                                                 to: formatter.date(from: "01 01 0001") ?? Date()) ?? Date()
                dateString.append("\(formatter.string(from: date)) ")
            } else if case .ampm = display {
                let row = display.includeIndexAt0 ? selectedRow : selectedRow+1
                dateString.append("\(row == 0 ? "AM" : "PM") ")
            } else {
                dateString.append("\(display.includeIndexAt0 ? selectedRow : selectedRow+1) ")
            }
        }
        formatter.dateFormat = format
        if let date = formatter.date(from: dateString) {
            self.date = date
        } else {
            self.reloadPicker()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let settedWidths = self.display.map({($0.rowWidth ?? 0) + 4}).reduce(0, +)
        let numberOfUnsettedWidths = CGFloat(self.display.filter({$0.rowWidth == nil}).count)
        let defaultWidth = (bounds.width - settedWidths) / numberOfUnsettedWidths
        return self.display[component].rowWidth ?? defaultWidth
    }
    
}
