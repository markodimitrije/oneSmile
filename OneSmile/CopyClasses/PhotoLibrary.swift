//
//  PhotoLibrary.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 31/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import Photos

class PhotoLibrary: NSObject {
    
    fileprivate var imgManager: PHImageManager
    fileprivate var requestOptions: PHImageRequestOptions
    fileprivate var fetchOptions: PHFetchOptions
    fileprivate var fetchResult: PHFetchResult<PHAsset>
    
    override init () {
        imgManager = PHImageManager.default()
        requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
    }
    
    var count: Int {
        return fetchResult.count
    }
    
    func setPhoto(at index: Int, completion block: @escaping (UIImage?)->()) {
        
        let maxSize = PHImageManagerMaximumSize
        //let maxSize = UIScreen.main.bounds.size //ovo daje warning unable to load image data...
        
        if index < fetchResult.count  {
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: maxSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                block(image)
            }
        } else {
            block(nil)
        }
    }
    
    func getAllPhotos() -> [UIImage] {
        
        var resultArray = [UIImage]()
        
        for index in 0..<fetchResult.count {
        
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                
                if let image = image {
                    resultArray.append(image)
                }
            }
        }
        
        return resultArray
    }
}





class OneSmilePhotoLibrary: PhotoLibrary {
    
//    var lastReadAsset: PHAsset?
//    var lastReadAssetUrl: URL? {
//        didSet {
//            //print("neko me je Set na \(String(describing: lastReadAssetUrl))")
//        }
//    }
    var lastReadIndex: Int?
    
    override init () { super.init()
        
        imgManager = PHImageManager.default()
        
        requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        fetchResult = PHFetchResult.init()
        
        if let folder = fetchFolderFromPhotoLibrary(name: "OneSmile") {
            fetchResult = PHAsset.fetchAssets(in: folder, options: fetchOptions)
        }
        
    }
    
    func reloadData() { //print("reloadData is called")
        
        imgManager = PHImageManager.default()
        
        requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        fetchResult = PHFetchResult.init()
        
        if let folder = fetchFolderFromPhotoLibrary(name: "OneSmile") {
            fetchResult = PHAsset.fetchAssets(in: folder, options: fetchOptions)
        }
        
        if let index = lastReadIndex {
            lastReadAsset = fetchResult[index]
        }
        
    }
    
    // MARK:- GET
    
    override func setPhoto(at index: Int, completion block: @escaping (UIImage?)->()) {
        
        let maxSize = PHImageManagerMaximumSize
        
        let asset = fetchResult.object(at: index) as PHAsset
        
        if index < fetchResult.count  {
            imgManager.requestImage(for: asset, targetSize: maxSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, info) in
                
                // SAVE u svojoj var, referencu na sliku koja je Zoomed (URL); mozda hoce da je delete...
                if let info = info {
                    print("sacuvaj ovaj url u svojoj Local VAR!")
                    lastReadAssetUrl = info["PHImageFileURLKey"] as? URL
                }
                
                block(image)
                
                self.lastReadIndex = index
                
                lastReadAsset = asset // zapamti u svom VAR (trebace observeru na GalleryVC)
            }
        } else {
            block(nil)
        }
    }
    
    func getPhotoDateInfo(at index: Int, completion block: @escaping (Date?)->()) {
        
        let maxSize = PHImageManagerMaximumSize
        
        let asset = fetchResult.object(at: index) as PHAsset
        
        block(asset.creationDate)
        
    }
    
    
    func getAllPhotos(targetSize: CGSize?) -> [UIImage] {
        
        let size = targetSize ?? UIScreen.main.bounds.size
        
        var resultArray = [UIImage]()
        
        for index in 0 ..< fetchResult.count {
            
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                
                if let image = image {
                    resultArray.append(image)
                }
            }
        }
        
        return resultArray
    }
    
    
    
    func getPhoto(targetSize: CGSize?, indexPath: IndexPath) -> UIImage {
        
        let size = targetSize ?? UIScreen.main.bounds.size
        
        var result: UIImage?
        
        imgManager.requestImage(for: fetchResult.object(at: indexPath.item) as PHAsset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
            
            result = image
            
        }
    
        return result ?? #imageLiteral(resourceName: "gear") // stavi neki template photo za teeth...
    }
    
    
    
    
    // prikazi mu alert da si successfully removed photo
    /*
    
    func deletePhoto(at index: Int, completion block: @escaping (UIImage?) -> ()) {
        
        
        
        PHPhotoLibrary().register(self) // prijavi se da budes Observer
        
        // implement me - obrisi photo
        
        guard let imgUrl = self.lastReadAssetUrl else { print("err.nemam asset url..")
            return
        }
        
        print("toDeleteAsset.imgUrl = \(imgUrl)")
        
       //let imageUrls = ["address...."]
        
        PHPhotoLibrary.shared().performChanges({
            
            let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: [imgUrl], options: nil)
            
            //PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
            
            PHAssetCollectionChangeRequest().removeAssets(imageAssetToDelete)
            
        }, completionHandler: { (success, error) in
            //print(success ? "Success" : error )
            if let err = error {
                print("deletePhoto.err.localizedDescription = \(err.localizedDescription)")
            }
            if success {
                print("deletePhoto.success = \(success)")
            }
        })
        
    }
    
    */
    
    
    func deletePhoto(atUrl url: URL?, completion block: @escaping (Bool?) -> ()) {
        
        //PHPhotoLibrary().register(self) // ne mozes da napravis instancu
        
        
        // implement me - obrisi photo
        
        guard let imgUrl = url else { print("err.nemam asset url..")
            return
        }
        
        print("toDeleteAsset.imgUrl = \(imgUrl)")
        
        let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: [imgUrl], options: nil)
        
        PHPhotoLibrary.shared().performChanges({

//            let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: [imgUrl], options: nil)

            //PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
            
            PHAssetCollectionChangeRequest().removeAssets(imageAssetToDelete)

        }, completionHandler: { (success, error) in
            //print(success ? "Success" : error )
            if let err = error {
                print("deletePhoto.err.localizedDescription = \(err.localizedDescription)")
                block(nil)
            }
            if success {
                
                lastReadAsset = imageAssetToDelete.firstObject
                
                print("deletePhoto.success = \(success)")
                block(success)
            }
        })
        
    }
    
}
