//
//  Notification_MV_VM.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 30/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import UserNotifications

// Notification_MV_VM

struct TimePeriodManager {
    
    static var backUpValue: Date {
        return Date.init(timeInterval: Constants.TimePeriod.twoWeeks,
                         since: Date.now)
    }
    
    // MARK:- racunske (shortcuts)
//
//    var nextNotifAt: Date? {
//        get {
//            // userDefaults...
//        }
//        set {
//            // userDefaults...
//        }
//    }
    
    
    
    
    
    // API:
    
    // AppDelegate ce ti javiti svaki put kad pokrece app...
    // ti kao MV_VM proveri da li imas saved value za notifikaciju
    // ako imas - all good
    // ako nemas, setuj je sam na koliko je preporuka - uzeo sam "2 weeks", moze sta god..
    
    func appDidFinishedLaunching() {
        
        setInitialValuesForConfiguredNotificationAt()
        
        setInitialValuesForNotificationAt()
        
    }
    
    func applicationWillEnterForeground() { // javlja ti APP_DELEGATE
        
        self.checkIfNotificationTimeHasElapsed() // npr. bio je van app 3 days a period je setovao na 2 days
        
    }
    
    func timerOnMainScreenHasElapsed() {
        
        self.checkIfNotificationTimeHasElapsed()
        
    }
    
    // MARK:- flow od API: "appDidFinishedLaunching"
    
    private func setInitialValuesForConfiguredNotificationAt() {
        
        if let _ = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt) {return}
        
        let now = Date.init(timeIntervalSinceNow: 0)
        
        userDefaults.set(now, forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt)
    }
    
    private func setInitialValuesForNotificationAt() {
        
        if let _ = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationAt) {return}
        
        let notificationTime = Date.init(timeIntervalSinceNow: 0).addingTimeInterval(Constants.TimePeriod.twoWeeks)
        
        
        userDefaults.set(notificationTime, forKey: UserDefaults.Keys.nextNotificationAt)
    }
    
    private func checkIfNotificationTimeHasElapsed() {
        
        guard let nextNotifAt = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationAt) as? Date else {return}
        
        if nextNotifAt < Date.now { // ako je vreme isteklo
            
            let savedInterval = reloadNotificationData()
            
            //postOneSmileNotification(inSeconds: savedInterval)
            
            deletePreviosNotificationsAndPostNewOne(inSeconds: savedInterval)
            
        }
        
    }
    
    // MARK:- worker
    
    private func reloadNotificationData() -> TimeInterval {
        
        var savedInterval = Constants.TimePeriod.twoWeeks // backUp value
        
        if let lastConfigured = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt) as? Date,
            let lastNextAt = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationAt) as? Date {
            savedInterval = lastNextAt.timeIntervalSince1970 - lastConfigured.timeIntervalSince1970
        }
        
        let now = Date.init(timeIntervalSinceNow: 0)
        userDefaults.set(now, forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt)
        
        let next = now.addingTimeInterval(savedInterval)
        userDefaults.set(next, forKey: UserDefaults.Keys.nextNotificationAt)
        
        return savedInterval
        
    }
    
    func userSetAlarmPeriod(value: Date) {
        
        userDefaults.set(value, forKey: UserDefaults.Keys.nextNotificationAt)
        alarmPeriodIsSet()
        
    }
    
    func appSetAlarmPeriod(value: Date) {
        
        userDefaults.set(value, forKey: UserDefaults.Keys.nextNotificationAt)
        alarmPeriodIsSet()
        
    }
    
    func whatIsSetPeriod() -> Date? { // RENAME !!
        
        return userDefaults.value(forKey: UserDefaults.Keys.nextNotificationAt) as? Date // moze da vrati NIL
            
    }
    
    // bilo da je app ili user setovao Picker
    // zapamti to vreme jer ti treba za reload intervala koji je odabrao....
    private func alarmPeriodIsSet() {
        
        userDefaults.set(Date.now, forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt)
        
    }
    
    
    // API: Calculate
    
    func whatIsSetInterval() -> TimeInterval? {
        
        guard let configuredAt = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt) as? Date,
            let nextNotifAt = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationAt) as? Date else {return nil}
        
        return nextNotifAt.timeIntervalSince(configuredAt)
        
    }
    
    //func whatIsSetIntervalToWait() -> (days: String, hours: String, minutes: String, seconds: String)? {
    func whatIsSetIntervalToWait() -> (days: Int, hours: Int, minutes: Int, seconds: Int)? {
        
        guard let nextNotifAt = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationAt) as? Date,
            let configuredAt = userDefaults.value(forKey: UserDefaults.Keys.nextNotificationIsConfiguredAt) as? Date else {
                return nil
        }
        
        return Date.getCalendarComponents(fromDate: configuredAt, toDate: nextNotifAt)
        
    }
    
    func whatIsSetIntervalToWait(fromDate: Date, toDate: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int)? {
        
        return Date.getCalendarComponents(fromDate: fromDate, toDate: toDate)
        
    }
    
    
    
}






func postOneSmileNotification(inSeconds seconds: TimeInterval) {
    
    let notificationConfigurator = NotificationConfigurator()
    
    notificationConfigurator.scheduleRandomNotification(inSeconds: seconds) {
        //print("One Smile notification is posted")
    }
}

func deletePreviousOnSmileNotificationsIfAny() {
    
    print("deletePreviousOnSmileNotificationsIfAny is CALLED")
    
    UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
        
        let oneSmileIdentifiers = (request.filter {$0.identifier  == Constants.OneSmileNotification.notificationRequestIdentifier}).map {$0.identifier}
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: oneSmileIdentifiers)
        
        print("brisem pending notifikacije: \(oneSmileIdentifiers)")
    }
    
}


func deletePreviosNotificationsAndPostNewOne(inSeconds seconds: TimeInterval) {
    
    deletePreviousOnSmileNotificationsIfAny()
    
    postOneSmileNotification(inSeconds: seconds)
}
