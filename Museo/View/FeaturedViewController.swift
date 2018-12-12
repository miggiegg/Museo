//
//  FeaturedViewController.swift
//  Museo
//
//  Created by Miguel Garcia on 12/10/18.
//  Copyright © 2018 Miguel Garcia Gonzalez. All rights reserved.
//

import UIKit
import WebKit

class FeaturedViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isEnabled = false
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        checkForInternet()
        loadWebsite()
    }
    
    func checkForInternet() {
        if Connectivity.isConnectedToInternet == false {
            let alertController = UIAlertController(title: "No Internet Connection", message: "Connect to the internet to experience the full app.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in }
            
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    func loadWebsite() {
        webView.allowsBackForwardNavigationGestures = true
        let myURL = URL(string: "https://miggiegg.github.io/Featured/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        webView.goBack()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                webView.isHidden = true
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                backButton.isEnabled = webView.canGoBack
                activityIndicator.stopAnimating()
                webView.isHidden = false
            }
        }
    }
    
}

final class FeaturedCacheCleaner {
    
    class func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
    }
    
}
