//
//  PhotoLibraryHelper.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 02/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct PhotoLibraryHelper {
    
    func oneSmileFolderPhotosCount() -> Int {
        
        return OneSmilePhotoLibrary().count
        
    }
    
}
