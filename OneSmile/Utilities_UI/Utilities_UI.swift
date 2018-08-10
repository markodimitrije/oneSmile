//
//  Utilities_UI.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 30/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class BorderedBtn: UIButton {
    
    func format(bgColor: UIColor?, borderColor: UIColor?, borderWidth: CGFloat?, cornerRadius: CGFloat?, titleColor: UIColor?, image: UIImage?, title: String?) {
        self.backgroundColor = bgColor
        self.layer.borderColor = borderColor?.cgColor
        self.layer.cornerRadius = cornerRadius ?? 0
        self.layer.borderWidth = borderWidth ?? 0
        self.setTitleColor(titleColor ?? .red, for: .normal)
        self.setImage(image, for: .normal)
        self.setTitle(title, for: .normal)
        
        self.sizeToFit() // resize its frame acording to text
    }
    
}
