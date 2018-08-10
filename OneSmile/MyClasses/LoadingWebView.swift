//
//  LoadingWebView.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 10/08/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LoadingWebView: UIWebView {
    
    func loadWebView(url: URL?) {
        guard let url = url else {return}
        let requestObj = URLRequest(url: url)
        self.delegate = self
        self.loadRequest(requestObj)// ovo radi ali je SYNC !
    }
    
}

extension LoadingWebView: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
//        print("webViewDidStartLoad .. implement me . . .. . ")
        showSpinner()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        print("webViewDidFinishLoad. .. implement me . . .. . ")
        removeSpinner()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        print("didFailLoadWithError .. implement me . . .. . ")
        removeSpinner()
    }
}

class OneSmileLoadingWebView: LoadingWebView {
    override func loadWebView(url: URL?) {
        guard let url = url else {return}
        
        showSpinner()
        
        let requestObj = URLRequest(url: url)
        self.delegate = self
        self.loadRequest(requestObj)// ovo radi ali je SYNC !
    }
    
    override func webViewDidStartLoad(_ webView: UIWebView) {
        // ne radi nista, default postavlja spinner, a ja ga postavljam kada pozivam 'loadWebView'
    }
}
