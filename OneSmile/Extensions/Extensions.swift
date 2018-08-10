//
//  Extensions.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 30/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

let userDefaults = UserDefaults.standard

extension UserDefaults {
    
    enum Keys {
        
        static let CurrentVersion = "currentVersion"
        static let DarkModeEnabled = "darkModeEnabled"
        
        static let nextNotificationAt = "nextNotificationAt" // A
        static let nextNotificationIsConfiguredAt = "nextNotificationIsConfiguredAt" // B
        
        // iz A i B mozes da reload Interval
        
    }
    
}

extension Date {
    static var now: Date {
        return Date.init(timeIntervalSinceNow: 0.0)
    }
}

extension Date {
    static func getCalendarComponentsAsText(fromDate: Date, toDate: Date) -> (days: String, hours: String, minutes: String, seconds: String) {
        
        let calendar = NSCalendar.current
        let cc: Set<Calendar.Component> = Set.init(arrayLiteral: .day, .hour, .minute, .second)
        let components = calendar.dateComponents(cc, from: fromDate, to: toDate)
        
        let days = String(components.day ?? 0)
        let hours = String(components.hour ?? 0)
        let minutes = String(components.minute ?? 0)
        let seconds = String(components.second ?? 0)
        
        return (days,hours,minutes,seconds)
    }
    
    static func getCalendarComponents(fromDate: Date, toDate: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        
        let calendar = NSCalendar.current
        let cc: Set<Calendar.Component> = Set.init(arrayLiteral: .day, .hour, .minute, .second)
        let components = calendar.dateComponents(cc, from: fromDate, to: toDate)
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        return (days,hours,minutes,seconds)
    }
}

extension Date {
    //let formatter = DateFormatter()
    //formatter.dateFormat = "yyyy/MM/dd HH:mm"
    static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("yyyy/MM/dd")
        return f
    }
    static var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("HH:mm")
        return f
    }
    static var dateAndtimeFormatter: DateFormatter {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("yyyy/MM/dd HH:mm")
        return f
    }
    
    
    static func justDateFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    static func justTimeFromDate(date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    static func dateAndTimeFromDate(date: Date) -> String {
        return dateAndtimeFormatter.string(from: date)
    }
    
}

