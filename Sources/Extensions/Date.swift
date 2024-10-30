//
//  Date.swift
//  Extensions
//
//  Created by Sudovsky on 15.05.2020.
//

import UIKit

public extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfWeek: Date {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2
        var interval = TimeInterval()

        var tmpDate = self
        _ = customCalendar.dateInterval(of: .weekOfMonth, start: &tmpDate, interval: &interval, for: tmpDate)
        return tmpDate
    }
    
    var month: Int {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2
        return Calendar.current.dateComponents([.month], from: self).month!
    }
    
    var weekOfMonth: Int {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2
        return Calendar.current.dateComponents([.weekOfMonth], from: self).weekOfMonth!
    }
    
    var day: Int {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2
        return Calendar.current.dateComponents([.day], from: self).day!
    }

    var weekday: Int {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }

    var year: Int {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2
        return Calendar.current.dateComponents([.year], from: self).year!
    }

    func stripTime(for component: Set<Calendar.Component> = [.year, .month, .day]) -> Date {
        let components = Calendar.current.dateComponents(component, from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func toString(format: String = "yyyy-MM-dd'T'HH:mm:ss", twentyFourOnly: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        var result = dateFormatter.string(from: self)

        if twentyFourOnly {
            result = result.replacingOccurrences(of: " AM", with: "")
            result = result.replacingOccurrences(of: " PM", with: "")
        }
        
        return result
    }
    
    func historyDate() -> String {
        
        if Calendar.current.isDateInToday(self) {
            if Calendar.current.component(.hour, from: self) == 0, Calendar.current.component(.minute, from: self) == 0 {
                return "Сегодня"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: self)
            }
        } else if Calendar.current.isDateInYesterday(self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "Вчера \(dateFormatter.string(from: self))"
        } else if Calendar.current.isDateInTomorrow(self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "Завтра \(dateFormatter.string(from: self))"
        } else {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm"
            let date = dateFormatter.string(from: self)
            
            if date == "01.01.01 00:00" {
                return ""
            } else {
                return date
            }
        }
    }

}

