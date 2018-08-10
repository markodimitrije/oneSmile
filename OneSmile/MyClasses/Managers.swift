//
//  Managers.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 08/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol Posting {
    
    func postToFb(info: [String: Any], fromViewController vc: UIViewController?)
    
}

class PostingManager: NSObject, Posting {
    
    func postToFb(info: [String: Any], fromViewController vc: UIViewController?) {
        
        guard let image = info["image"] as? UIImage, let date = info["date"] else { return }
        
        let compresed = image // ovo je full
        
        //let compresed = image.jpegImageScaledBy(factor: 0.05) // za test....
        
        DispatchQueue.main.async {
            
            //let activityItems: [Any] = [image, date] //saljem image i create_date
            let activityItems: [Any] = [compresed, date] //saljem image i create_date
            
            let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            vc?.present(avc, animated: true)
            
        }
        
    }
    
    
}


extension UIImage {
    func jpegImageScaledBy(factor: CGFloat) -> UIImage? {
        guard let data = UIImageJPEGRepresentation(self, factor) else {return nil}
        let compressed = UIImage.init(data: data)
        return compressed
    }
}

