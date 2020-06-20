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
        case year(String, CGFloat? = nil)
        case month(String, CGFloat? = nil)
        case day(String, CGFloat? = nil)
        case hour24(CGFloat? = nil)
        case hour12(CGFloat? = nil)
        case ampm(CGFloat? = nil)
        case minute(CGFloat? = nil)
        case second(CGFloat? = nil)
        case fullDate(String, CGFloat? = nil)
        
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
    }
    
    private var formatter: DateFormatter = DateFormatter()
    
    var dateChanged: ((Date?)->Void)?
    var date: Date? {
        didSet {
            reloadPicker()
            dateChanged?(date)
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
}

extension SundeedDatePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { display.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        formatter.dateFormat = "dd MM yyyy"
        return display[component].numberOfRows(for: self.date ?? formatter.date(from: "01 01 2000")!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
            return formatter.string(from: date)
        } else if case .ampm = display {
            return row == 0 ? "AM" : "PM"
        } else if let date = formatter.date(from: "\(display.includeIndexAt0 ? row : row+1)") {
            formatter.dateFormat = displayFormat
            return formatter.string(from: date)
        }
        return "---"
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
