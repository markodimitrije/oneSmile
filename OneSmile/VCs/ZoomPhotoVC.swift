//
//  ZoomPhotoVC.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import Photos

class ZoomPhotoVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tabBarView: UITabBar!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    @IBAction func pinchDetected(_ sender: UIPinchGestureRecognizer) {
        pinchIsDetected(recognizer: sender)
    }
    
    @IBAction func panDetected(_ sender: UIPanGestureRecognizer) {
        panIsDetected(recognizer: sender)
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        doubleTapIsDetected(recognizer: sender)
    }
    
    // MARK:- stored vars
    
    var imgViewCenter = CGPoint.zero // zapamtice te didAppear
    
    override func viewDidLoad() { super.viewDidLoad()
        
        imageView?.image = image
        
        dataManager.getDateInfo(imageAtIndex: imgIndex) { [weak self] (date) in
            
            guard let date = date else {return}
            //let dateRes = Date.justDateFromDate(date: date)
            //let timeRes = Date.justTimeFromDate(date: date)
            let res = Date.dateAndTimeFromDate(date: date)
            
            self?.navigationItem.title = res
            
        }
        
        tapRecognizer.numberOfTapsRequired = 2
        
        PHPhotoLibrary.shared().register(self) // osluskuj ako je neko on-off favourite
        
        updateTabBarViewImages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZoomPhotoVC.lastAssetHasChanges), name: Constants.NotificationNames.lastAssetHasChanges, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imgViewCenter = imageView.center // treba mi za doubleTapGesture -> reposition image
    }
    
    var dataManager = Gallery_MV_VM()
    
    // MARK: API
    
    var imageName: String = ""
    
    var image: UIImage?
    
    var imgIndex: Int?
    
    var imgUrlInPhotoLibrary: URL?

    // MARK:-Private (reaguju na user tap...)
/*
    fileprivate func userWantsToDeletePhoto() {
        
        print("ZoomPhotoVC.userWantsToDeletePhoto")
        
        print("ZoomPhotoVC.pre brisanja: \(dataManager.photoLibrary.count)")
        
        // javi svom modelu da hoce da obrise sliku sa url-om koju upravo gleda na ZoomPhotoVC
        
        dataManager.deletePhoto(atUrl: imgUrlInPhotoLibrary) { (success) in
            
            if let success = success, success {
                print("ZoomPhotoVC.kaze da je obrisao sliku...")
                
                print("ZoomPhotoVC.posle brisanja: \(Gallery_MV_VM().photoLibrary.count)") // mora nova instance ili neki update na postojecoj
                
                print("daj mu alert da je obrisao sliku...")
                
            } else {
                print("ZoomPhotoVC.kaze da NIJE obrisao sliku...")
            }
            
        }
        
    }
*/
    
    
    
    
    fileprivate func toggleFavourite() { //print("ZoomPhotoVC.toggleFavourite is called")
        
        guard let lastReadAsset = lastReadAsset else {return}
        
        //dataManager.toggleFavourite(asset: lastReadAsset)
        
        dataManager.toggleFavourite(asset: lastReadAsset) { (success) in
            if let success = success, success {
                
                self.dataManager.photoLibrary.reloadData() // sada je neko drugaciji Favourite...
                
                //self.updateTabBarViewImages()
                
            }
        }
        
    }
    
    
    private func updateTabBarViewImages() {
        DispatchQueue.main.async {
            var items = [UITabBarItem]()
            items.append(self.tabBarView.items!.first!) // share je uvek share...
            guard let isFavourite = lastReadAsset?.isFavorite else {return}
            let image = isFavourite ? #imageLiteral(resourceName: "favourite_on") : #imageLiteral(resourceName: "favourite_off")
            let new = UITabBarItem.init(title: "", image: image, tag: 1)
            items.append(new)
            self.tabBarView.setItems(items, animated: false)
        }
        
    }
    
    
    
    fileprivate func userWantsToSharePhoto() { print("ZoomPhotoVC.userWantsToSharePhoto")
        
        // trazi modelu info !
        
        guard let image = imageView.image, let date = lastReadAsset?.creationDate else {return}
        
        let info: [String: Any] = ["image": image, "date": date]
        
        PostingManager().postToFb(info: info, fromViewController: self)
        
    }
    
     //MARK:- respond to gestures
    
    private func pinchIsDetected(recognizer: UIPinchGestureRecognizer){

        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
        
    }
    
    private func panIsDetected(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view) // ovde nije Transform !
        
    }
    
    private func doubleTapIsDetected(recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransform.identity
            view.center = imgViewCenter
        }
    }
    
    // MARK: - objc
    
    @objc func lastAssetHasChanges() { // okida global var kada ima promene...
        self.updateTabBarViewImages()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
}


extension ZoomPhotoVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 0: userWantsToSharePhoto()
            case 1: toggleFavourite()
        default: break
        }
    }
    
}

extension ZoomPhotoVC: PHPhotoLibraryChangeObserver {
    
    // ovo se poziva 10 puta a samo je 1 change..
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {  print("ZoomPhotoVC.photoLibraryDidChange")
        
        guard let assetId = lastSavedAssetIdentifier,
            let myAsset = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject,
            let details = changeInstance.changeDetails(for: myAsset) else {
            print("photoLibraryDidChange.err/nemam assetId|myAsset|details..."); return
        }
        
        print("photoLibraryDidChange.AllGood, setujem lastReadAsset sa Fav = \(lastReadAsset!.isFavorite)...")
        
        lastReadAsset = details.objectAfterChanges // ovo je bitno
        
    }
    
}
