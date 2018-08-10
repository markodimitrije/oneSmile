//
//  GlobalFuncs.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 30/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Photos

//func saveToPhotoLibrary(data: Data, completion: @escaping (PHAsset?) -> ()) {

func savePhotoToPhotoLib(data: Data, inAlbumFolder folderName: String, completion: @escaping (PHAsset?) -> ()) {
    var assetIdentifier: String?
    PHPhotoLibrary.requestAuthorization { (status) in
        if status == .authorized {
            PHPhotoLibrary.shared().performChanges({

                let creationRequest = PHAssetCreationRequest.forAsset()
                let placeholder = creationRequest.placeholderForCreatedAsset



                //creationRequest.addResource(with: .photo, data: data, options: .none) // ovo radi

                let fileName = "OneSmile" + "\(Date.now)"
                let options = PHAssetResourceCreationOptions.init()
                options.originalFilename = fileName

                //creationRequest.addResource(with: .photo, data: data, options: .none)
                creationRequest.addResource(with: .photo, data: data, options: options)

                assetIdentifier = placeholder?.localIdentifier

            }, completionHandler: { (success, error) in
                if let error = error {
                    print("There was an error saving to the photo library: \(error)")
                }
                var asset: PHAsset? = .none
                if let assetIdentifier = assetIdentifier {
                    asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: .none).firstObject
                }
                completion(asset)
            })
        } else {
            print("Need authorisation to write to the photo library")
            completion(.none)
        }
    }
}


func saveToPhotoLibrary(data: Data, inAlbumFolder folderName: String, completion: @escaping (PHAsset?) -> ()) {
    
    func createImageAndSaveItToAlbum(data: Data, album: PHAssetCollection, completion: @escaping (_ asset: PHAsset?) -> ()) {
        
        guard let photo = UIImage.init(data: data) else {
            print("saveToPhotoLibrary.createImageAndSaveItToAlbum.can't create image from data")
            completion(nil)
            return
        }
        
        createPhotoOnAlbum(photo: photo, album: album, completion: { (asset) in
            
            completion(asset)
            
        })
        
    }
    
    if !doesFolderAlreadyExistsInPhotoLibrary(name: folderName) { // ako vec ne postoji u PhotoLibrary...
        
        createPhotoLibraryAlbum(name: folderName) { (album) in
            
            guard let album = album else { print("saveToPhotoLibrary.nemam album"); return }
            
            createImageAndSaveItToAlbum(data: data, album: album) { (asset) in
                completion(asset)
            }
            
        }
        
    } else {
        
        // bilo bi dobro da fetch postojeci ALBUM, ili uzmi API od ranije, ali mu reci da ubaci u folder
        //savePhotoToPhotoLib(data: data, inAlbumFolder: folderName) { (asset) in
            
        guard let album = fetchFolderFromPhotoLibrary(name: "OneSmile") else {return}
        
        createImageAndSaveItToAlbum(data: data, album: album) { (asset) in
            completion(asset)
        }
        
    }
    
}



// Swift 3.0
func createPhotoLibraryAlbum(name: String) {
    
    var albumPlaceholder: PHObjectPlaceholder?
    
    PHPhotoLibrary.shared().performChanges({
        
        // Request creating an album with parameter name
        
        let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        // Get a placeholder for the new album
        albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        
    }, completionHandler: { success, error in
        if success {
            guard let placeholder = albumPlaceholder else {
                fatalError("Album placeholder is nil")
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            
            guard let album: PHAssetCollection = fetchResult.firstObject else {
                // FetchResult has no PHAssetCollection
                return
            }
            
            print("createPhotoLibraryAlbum: Saved successfully!")
            print(album.assetCollectionType)
        }
        else if let _ = error {
            // Save album failed with error
        }
        else {
            // Save album failed with no error
        }
    })
}


// Swift 3.0 modify
func createPhotoLibraryAlbum(name: String, completion: @escaping (PHAssetCollection?) -> ()) {
    
    var albumPlaceholder: PHObjectPlaceholder?
    
    PHPhotoLibrary.shared().performChanges({
        
        // Request creating an album with parameter name
        
        let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        // Get a placeholder for the new album
        albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        
    }, completionHandler: { success, error in
        if success {
            guard let placeholder = albumPlaceholder else {
                fatalError("Album placeholder is nil")
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            
            guard let album: PHAssetCollection = fetchResult.firstObject else {
                // FetchResult has no PHAssetCollection
                return
            }
            
            print("createPhotoLibraryAlbum: Saved successfully!")
            print(album.assetCollectionType)
            completion(album)
        }
        else if let _ = error {
            // Save album failed with error
            completion(nil)
        }
        else {
            // Save album failed with no error
            completion(nil)
        }
    })
}


// Swift 3.0
func createPhotoOnAlbum(photo: UIImage, album: PHAssetCollection, completion: @escaping (PHAsset?) -> ()) {
    
    var assetIdentifier: String?
    
    PHPhotoLibrary.shared().performChanges({
        // Request creating an asset from the image
        let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
        // Request editing the album
        guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
            // Album change request has failed
            return
        }
        // Get a placeholder for the new asset and add it to the album editing request
        guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
            // Photo Placeholder is nil
            return
        }
        
        assetIdentifier = photoPlaceholder.localIdentifier
        
        albumChangeRequest.addAssets([photoPlaceholder] as NSArray)
        
    }, completionHandler: { success, error in
        if success {
            
            var asset: PHAsset? = .none
            if let assetIdentifier = assetIdentifier {
                asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: .none).firstObject
            }
            
            completion(asset)
            
        }
        else if let e = error {
            // Save photo failed with error
        }
        else {
            // Save photo failed with no error
        }
    })
}

// trazi foldere (UserCollections) na top levelu (bolje je svuda u Modelu, kroz sve Levels...)
// onda ih transform u njihova Imena
// i onda vidi da li se zadati folderName nalazi u tom nizu...

func doesFolderAlreadyExistsInPhotoLibrary(name: String) -> Bool {
    
    let topLevelUserCollections = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
    
    var folderNames = [String]()
    
    for i in 0 ..< topLevelUserCollections.count {
        guard let name = topLevelUserCollections.object(at: i).localizedTitle else {continue}
        folderNames.append(name)
    }
    
    print("folderNames = \(folderNames)")
    
    return folderNames.contains(name)
    
}

func fetchFolderFromPhotoLibrary(name: String) -> PHAssetCollection? {
    
    let topLevelUserCollections = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
    
    var folders = [PHAssetCollection]()
    
    for i in 0 ..< topLevelUserCollections.count {
        
        let collection = topLevelUserCollections.object(at: i)
        
        guard let title = collection.localizedTitle,
            let folder = collection as? PHAssetCollection else {continue}
        
        if title == name {
            folders.append(folder)
        }
    }
    
//    print("folders.count = \(folders.count)")
    
    return folders.first
    
}
