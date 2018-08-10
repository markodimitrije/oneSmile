//
//  GalleryVC.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import Photos

class GalleryVC: UIViewController {
    
    var dataProvider = Gallery_MV_VM()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellBounds = CGSize.zero
    
    override func viewDidLoad() { super.viewDidLoad()
        
//        print("registruj GalleryVC za OBSERVERA!")
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            PHPhotoLibrary.shared().register(self)
            
            if status == .authorized {
                
                //print("status je OK, postujem notifikaciju za 'userGrantedPermissionsToAccessPhotoLibrary'")
                
                NotificationCenter.default.post(name: Constants.NotificationNames.userGrantedPermissionsToAccessPhotoLibrary,
                                                object: nil)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPhotoSavedInPhotoLibrary(_:)), name: Constants.NotificationNames.cameraPhotoSavedInPhotoLibrary, object: nil)
        
        dataProvider.photoLibrary.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        
        //PHPhotoLibrary.shared().unregisterChangeObserver(self)
        
    }
    
    // MARK:- Privates, reaguju na user action
    
    private func userTappedOnCell(withIndexPath indexPath: IndexPath) {
        print("otvori full photo za ip = \(indexPath.item)")
        
        guard let zoomedPhotoVC = mainStoryboard.instantiateViewController(withIdentifier: "ZoomPhotoVC") as? ZoomPhotoVC else {
            return
        }
        
        dataProvider.getPhoto(index: indexPath.item) { (image) in
            
            print("image = \(String(describing: image))")
            
            zoomedPhotoVC.image = image // posalji mu sliku da prikaze
            zoomedPhotoVC.imgUrlInPhotoLibrary = lastReadAssetUrl // tamo postoji opcija delete (param je url...)
            zoomedPhotoVC.imgIndex = indexPath.item // javi mu koja je po redu, ne treba jer imam url...
            
        }
        
        self.navigationController?.pushViewController(zoomedPhotoVC, animated: true)
        
    }
    
    
    func reloadData() {
        
//        print("reloadData is CALLED") // gledaj da ovo ne zoves cesce nego sto je neophodno....
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.dataProvider = Gallery_MV_VM()
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
            }
            
        }
        
    }
    
    //MARK:- objc
    
    @objc func newPhotoSavedInPhotoLibrary(_ notification: Notification) {
        //print("GalleryVC.newPhotoSavedInPhotoLibrary.notification = \(notification)")
        if let asset = notification.object as? PHAsset { // imam to sto ocekujem...
            lastReadAsset = asset
        }
    }
    
}

extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.photoLibrary.count // jako vazno, jer na sebi NEMA CASHE
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryPhotoCell else {return UICollectionViewCell.init()}
        
        if cellBounds == CGSize.zero { cellBounds = cell.bounds.size }
        
        let image = self.dataProvider.photoLibrary.getPhoto(targetSize: cell.bounds.size, indexPath: indexPath)
        
        cell.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.userTappedOnCell(withIndexPath: indexPath)
        
    }
    
}








extension GalleryVC: PHPhotoLibraryChangeObserver {
    
    // ovo se poziva 10 puta a samo je 1 change..
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
//        print("photoLibraryDidChange")
        
        guard let asset = lastReadAsset else {
            return
        }
        guard let assetCollection = PHAssetCollection.fetchAssetCollectionsContaining(asset, with: .album, options: nil).firstObject else {
            return
        }
        
        guard let _ = changeInstance.changeDetails(for: assetCollection) else {
            return
        }
        
        // ako si dosao do ovde, onda ti je javljeno za promene u OneSmile album collection-u
        
        reloadData() // samo tada, update-uj UI
        
    }
    
}








