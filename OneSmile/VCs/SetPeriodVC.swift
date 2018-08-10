//
//  SetPeriodVC.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class SetPeriodVC: UIViewController {
    
    @IBOutlet weak var confirmBtn: BorderedBtn!
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var daysDescLbl: UILabel!
    @IBOutlet weak var hoursDescLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    
    
    @IBOutlet weak var minDescLbl: UILabel!
    @IBOutlet weak var minLbl: UILabel!
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        datePickerValueIsChanged(sender: sender)
        
    }
    
    @IBAction func confirmTapped(_ sender: UIButton) {
        confirmIsTapped() // izmestac...
    }
    
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    
    override func viewDidLoad() { super.viewDidLoad()
        set(dateAndTimePicker: dateAndTimePicker)
        formatDatePicker()
        formatConfirmBtn()
        //updateAlarmTimeInterval()
        updateAlarmTimeInterval(withInterval: nil)
    }
    
    
    
    // MARK:- properties
    
    //let notificationConfigurator = NotificationConfigurator()
    
    let tpm = TimePeriodManager() // njegov MV_VM, calculator i sl...
    
    // MARK:- Privates, reaguju na user action
    
    private func gearBtnIsTapped() {
        
        // idi na drugi vc ekran 2
        
    }
    
    // javice ti IBAction
    // recalculate interval, confirmBtn change color
    private func datePickerValueIsChanged(sender: UIDatePicker) {
        confirmBtn.backgroundColor = .green
        let interval = tpm.whatIsSetIntervalToWait(fromDate: Date.now, toDate: sender.date)
        updateAlarmTimeInterval(withInterval: interval)
    }
    
    
    private func confirmIsTapped() {
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate {
            appDel.configureUserNotifications()
        }
        
        tpm.appSetAlarmPeriod(value: dateAndTimePicker.date) // sacuvaj mu vreme u UserDefaults
        
        guard let dispatchAfter = tpm.whatIsSetInterval() else {return}

        //postOneSmileNotification(inSeconds: dispatchAfter)
        
        deletePreviosNotificationsAndPostNewOne(inSeconds: dispatchAfter)
        
//        notificationConfigurator.scheduleRandomNotification(inSeconds: dispatchAfter) {
//        //notificationConfigurator.scheduleRandomNotification(inSeconds: 2) { //FIRE MOMENTARILY
//            print("konfigurisao sam notifikaciju....")
//        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func formatDatePicker() {
        dateAndTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    private func formatConfirmBtn() {
        
        let btnTitle = NSLocalizedString("Strings.Confirm", comment: "")
        
        confirmBtn.format(bgColor: .clear, borderColor: .white, borderWidth: 1.0, cornerRadius: 4.0, titleColor: .white, image: nil, title: btnTitle)
        
        
    }
    
//    private func updateAlarmTimeInterval() {
//        guard let interval = tpm.whatIsSetIntervalToWait() else {return}
//        DispatchQueue.main.async {
//            self.daysLbl?.text = "\(interval.days)"
//            self.hoursLbl?.text = "\(interval.hours)"
//            self.minLbl?.text = "\(interval.minutes)"
//        }
//    }
    
    private func updateAlarmTimeInterval(withInterval interval: (days: Int, hours: Int, minutes: Int, seconds: Int)?) {
        let value = interval ?? tpm.whatIsSetIntervalToWait()
        guard let result = value else {return}
        DispatchQueue.main.async {
            self.daysLbl?.text = "\(result.days)"
            self.hoursLbl?.text = "\(result.hours)"
            self.minLbl?.text = "\(result.minutes)"
        }
    }
    
    
    
    
    
    
    
    private func set(dateAndTimePicker: UIDatePicker) {
        
        reloadDatePicker()
        
        //dateAndTimePicker.minimumDate = Date.init(timeIntervalSinceNow: 0.0) // ne moze biti manji od NOW
        dateAndTimePicker.minimumDate = Date.init(timeIntervalSinceNow: Constants.TimePeriod.notificationMinInterval) // ne moze biti manji od NOW+10min
    }
    
    private func reloadDatePicker() { // vrati na koliko si setovan ili backUp value
        //print("next notification set at = \(String(describing: tpm.whatIsSetPeriod()))")
        dateAndTimePicker.date = tpm.whatIsSetPeriod() ?? TimePeriodManager.backUpValue
    }
    
}



struct NotificationConfigurator {
    
    // API:
    
    func scheduleRandomNotification(inSeconds: TimeInterval, completion: @escaping () -> ()) {
        
        let imageName = "oneSmile"
        
        let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png")!
        
        guard let attachment = try? UNNotificationAttachment.init(identifier: "attachment", url: imageURL, options: nil) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Time elapsed"
        content.subtitle = "subtitle"
        content.attachments = [attachment]
        content.body = "TIME FOR NEW ONE SMILE SELFIE 🤗"
        content.categoryIdentifier = newOneSmileCategoryName
        
        //content.sound // implement me
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)

        //let t = UNCalendarNotificationTrigger.init(dateMatching: <#T##DateComponents#>, repeats: false) implement me
        
        //let name = "\(arc4random())"
        let name = Constants.OneSmileNotification.notificationRequestIdentifier // vazno je za eventualni cancel
        
        let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error =  error {
                print(error)
            }
            completion()
        })
    }
    
}


