//
//  Gallery_MV_VM.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

//import Foundation
import UIKit
import Photos

class Gallery_MV_VM: NSObject {
    
    var photoLibrary = OneSmilePhotoLibrary()
    // Number of all photos
    
    // MARK:- GET photo
    
    func getPhoto(index: Int, completion: @escaping (_ image: UIImage?) -> Void) {

        self.photoLibrary.setPhoto(at: index, completion: completion)
        
    }
    
    // MARK:- GET date info
    
    func getDateInfo(imageAtIndex index: Int?, handler: @escaping (Date?) -> ()) {
        
        guard let index = index else { handler(nil); return }
        
        self.photoLibrary.getPhotoDateInfo(at: index) { (date) in
            
            handler(date)
            
        }
        
    }
    
    // MARK:- DELETE photo
    /*
    func deletePhoto(index: Int, completion: @escaping (_ image: UIImage?) -> Void) {
        
        // ovaj zove PhotoLibrary, neki drugi MV_VM bi mogao da zove doc folder itd....
        
        photoLibrary.deletePhoto(at: index, completion: completion)
        
    }
    */
    
    func deletePhoto(atUrl url: URL?, completion: @escaping (_ success: Bool?) -> Void) {
        
        // ovaj zove PhotoLibrary, neki drugi MV_VM bi mogao da zove doc folder itd....
        
        photoLibrary.deletePhoto(atUrl: url, completion: completion)
        
    }
    
    
    // MARK:- Favourite
    
//    func toggleFavourite(asset: PHAsset) {
//
//        var assetIdentifier: String?
//
//        print("asset.initially: isFavorite = \(asset.isFavorite)")
//
//        PHPhotoLibrary.shared().performChanges({
//
//            let changeRequest = PHAssetChangeRequest.init(for: asset)
//
//            print("changeRequest.initially: isFavorite = \(changeRequest.isFavorite)")
//
//            if let placeholder = changeRequest.placeholderForCreatedAsset {
//                assetIdentifier = placeholder.localIdentifier // sacuvaj ga, treba ti u handleru !
//            }
//
//            changeRequest.isFavorite = !changeRequest.isFavorite
//
//            lastReadAsset = nil // treba mu reload...
//
//            print("changeRequest.posle tap: isFavorite = \(changeRequest.isFavorite)")
//
//        }, completionHandler: { (success, error) in
//            if let error = error {
//                print("There was an error saving to the photo library: \(error)")
//            }
//            var asset: PHAsset? = .none
//            if let assetIdentifier = assetIdentifier {
//
//                asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: .none).firstObject
//
//                lastReadAsset = asset
//            }
//
//            //completion(asset)
//        })
//
//    }
    
    func toggleFavourite(asset: PHAsset, completion: @escaping (_ success: Bool?) -> Void) {
        
        print("asset.initially: isFavorite = \(asset.isFavorite)")
        
        PHPhotoLibrary.shared().performChanges({
            
            let changeRequest = PHAssetChangeRequest.init(for: asset)
            
            lastSavedAssetIdentifier = asset.localIdentifier // observer ce uhvatiti promenu
            
            changeRequest.isFavorite = !asset.isFavorite // podesi za photoLibrary
            
            print("changeRequest.posle tap: isFavorite = \(changeRequest.isFavorite)")
            
        }, completionHandler: { (success, error) in
            if let error = error {
                print("There was an error saving to the photo library: \(error)")
                completion(nil)
            }
            
            completion(success)
        })
        
    }

}
