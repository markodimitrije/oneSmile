//
//  GlobalFuncss.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 10/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// MARK: UTILITIES

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func showSpinner() {
    let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    spinner.tag = 1
    spinner.center = spinerPresenterView?.center ?? CGPoint.zero
    spinner.startAnimating()
    spinerPresenterView?.addSubview(spinner)
}
func removeSpinner() {
    DispatchQueue.main.async {
        let spinner = spinerPresenterView?.subviews.first(where: {$0.tag == 1})
        spinner?.removeFromSuperview()
    }
}
