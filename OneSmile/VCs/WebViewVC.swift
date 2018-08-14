//
//  WebViewVC.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {
    
    @IBOutlet weak var webView: OneSmileLoadingWebView!
    
    override func viewDidLoad() { super.viewDidLoad()
        
        configureAndLoadWebView()
    }
    
    // MARK:- Privates, reaguju na user action
    
    private func configureAndLoadWebView() { //Constants.Urls.oneSmileWebSiteAddress
        
        guard let url = URL.init(string: Constants.Urls.oneSmileWebSiteAddress) else {return}
        
        webView?.loadWebView(url: url)
        
    }

}


