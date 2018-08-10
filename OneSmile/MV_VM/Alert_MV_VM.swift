//
//  Alert_MV_VM.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 02/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit



struct Alert_MV_VM {
    
    // API
    
    func getAlertFor(alertType: AlertType, handler: ((UIAlertAction) -> () )?) -> UIAlertController? {
        
        switch alertType {
            case .galleryEmptyTakePhoto: return getGalleryEmptyTakePhotoAlertVC(handler: handler)
        }
        
    }
    
    // Privates
    
    private func getGalleryEmptyTakePhotoAlertVC(handler: ((UIAlertAction) -> () )?) -> UIAlertController? {
        let title = AlertInfo.galleryEmptyTakePhotoInfo.title
        let msg = AlertInfo.galleryEmptyTakePhotoInfo.message
        let btnTitle = AlertInfo.galleryEmptyTakePhotoInfo.btnOK
        
        let alertVC = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: btnTitle, style: .default, handler: handler)
        
        alertVC.addAction(okAction)
        
        return alertVC
        
    }
    
    
}
