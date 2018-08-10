//
//  Model.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 02/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//


import Foundation
import Photos

enum AlertType {
    case galleryEmptyTakePhoto
}

struct AlertInfo {
    struct galleryEmptyTakePhotoInfo {
        static let title = NSLocalizedString("Strings.Alert.GalleryEmptyTakePhoto.title", comment: "")
        static let message = NSLocalizedString("Strings.Alert.GalleryEmptyTakePhoto.message", comment: "")
        static let btnOK = NSLocalizedString("Strings.Alert.GalleryEmptyTakePhoto.ok", comment: "")
    }
}
