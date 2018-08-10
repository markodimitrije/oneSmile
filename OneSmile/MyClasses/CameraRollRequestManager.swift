//
//  NotificationResponseManager.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 30/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import UserNotificationsUI
import UserNotifications
import Photos

class CameraRollRequestManager { // rename CameraRollRequestManager
    
    let imgPickerVC = UIImagePickerController.init()
    
    // MARK:- API
    
    func didReceiveResponse(_ response: UNNotificationResponse) -> Void {
        
        print("CameraRollRequestManager.didReceiveResponse")
        
        switch response.actionIdentifier {
            
            case Constants.OneSmileNotification.dismissActionIdentifier: break
            
            default: userWantsToTakeSelfie()
            
        }
        
    }
    
    func userAsksForCameraRoll() { // zove alert sa MainVC koji se prikaze kada je empty gallery...
        
        self.userWantsToTakeSelfie()
        
    }
    
    // MARK:- PRIVATES (flow from API)
    
    private func userWantsToTakeSelfie() {
        
        guard let topVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? MyNavigationController else { print("userWantsToTakeSelfie.nemam ref na NAVIG!"); return }
        
        //print("imam navig prikazi na njemu open camera i slicno....")
        
        openCamera(refVC: topVC)
    
    }
    
    fileprivate func openCamera(refVC: MyNavigationController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imgPickerVC.sourceType = .camera
            
            imgPickerVC.delegate = refVC
            
            openPhotoResourceIfAuthorizationIsGranted(refVC: refVC)
            
        } else {
            
            print("openCamera.err: camera is RESTRICTED - prikazi mu alert...")
            
        }
        
    }
    
    fileprivate func openPhotoResourceIfAuthorizationIsGranted(refVC: MyNavigationController) {
        
        refVC.present(imgPickerVC, animated: true, completion: nil)
        
    }
    
}















class MyNavigationController: UINavigationController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func userTakesPhoto(_ image: UIImage) { // javljas samom sebi, rename image, persistance itd... reload UI if on Gallery....
        
        guard let imgData = UIImageJPEGRepresentation(image, 1) else {return}
        
        /* -> ovo radi ali ne ubacuje u folder One Smile
        saveToPhotoLibrary(data: imgData) { (asset) in
            print("valjda saved u photo library")
        }
        */
        
        // ovo ubacuje u Photo Library + create One Smile folder u njemu
        
        saveToPhotoLibrary(data: imgData, inAlbumFolder: "OneSmile") { (asset) in
            
            NotificationCenter.default.post(name: Constants.NotificationNames.cameraPhotoSavedInPhotoLibrary, object: asset)
            
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
            
        self.userTakesPhoto(image)
        
        //self.popViewController(animated: true) // nisi ga PUSH nego PRESENT !
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
    }
    
}



