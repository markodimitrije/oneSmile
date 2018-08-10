//
//  NotificationViewController.swift
//  OneSmileNotificationContent
//
//  Created by Marko Dimitrijevic on 30/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var takeSelfieBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func btnTapped(_ sender: UIButton) {
        btnIsTapped(sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
    
    private func btnIsTapped(sender: UIButton) {
        switch sender.tag {
        case 1: userWantsToUseCamera()
        default: break
        }
    }
    
    private func userWantsToUseCamera() {
        print("otvori mu camera da moze da slika...")
    }

}
