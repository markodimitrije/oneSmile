//
//  Globals.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 08/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Photos


var lastSavedAssetIdentifier: String?
var lastReadAsset: PHAsset? {
    didSet {
//        print("lastReadAsset is SET SET SET")
//        print("lastReadAsset.isFavorite = \(lastReadAsset?.isFavorite)")
        NotificationCenter.default.post(name: Constants.NotificationNames.lastAssetHasChanges, object: nil)
    }
}
var lastReadAssetUrl: URL?
var isFavourite: Bool? // ovaj var imam iz razloga sto ne mogu da uradim save od lastReadAsset pri change favourite (sranje...)

let spinerPresenterView: UIView? = UIApplication.shared.windows.first?.rootViewController?.view

let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
