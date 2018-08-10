//
//  Constants.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct Constants {
    struct Urls {
        static let oneSmileWebSiteAddress: String = "https://www.google.rs/"
        static let fabricAddress: String = "https://fabric.io/total-album/ios/apps/com.dkrtalic.stickersapp/dashboard/retention"
        static let googleAddress: String = "https://www.google.rs/"
    }
    struct TimePeriod {
        static let twoWeeks: TimeInterval = 2*7*24*60*60
        static let notificationMinInterval: TimeInterval = 10*60
    }
    struct OneSmileNotification {
        //static let cameraActionIdentifier = "camera"
        static let dismissActionIdentifier = "dismiss"
        static let notificationRequestIdentifier = "oneSmile"
    }
    struct NotificationNames {
        //static let cameraPhotoSavedInPhotoLibraryNotificationName = Notification.Name("cameraPhotoSavedInPhotoLibrary")
        static let cameraPhotoSavedInPhotoLibrary: Notification.Name = Notification.Name("cameraPhotoSavedInPhotoLibrary")
        
        static let userGrantedPermissionsToAccessPhotoLibrary: Notification.Name = Notification.Name("userGrantedPermissionsToAccessPhotoLibrary")
        
        static let lastAssetHasChanges: Notification.Name = Notification.Name("lastAssetHasChanges")
    }
}


