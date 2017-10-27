//
//  AuthWebViewController.swift
//  MyApp
//
//  Created by Ronin on 26/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import WebKit

class AuthWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView:WKWebView!
    var token:String?
    var userId:String?
    
    var activityIndicator: UIActivityIndicatorView!
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://oauth.vk.com/authorize?client_id=\(Constants.VK.accessToken)&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.68&state=123456"
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.color = .black
    
        view.addSubview(activityIndicator)
        activityIndicator?.startAnimating()
        
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.stopAnimating()
        let range = webView.url?.absoluteString.lowercased().range(of: "access_token")
        if !(range?.isEmpty ?? true), let urlString = webView.url?.absoluteString {
            let data = urlString.components(separatedBy: CharacterSet(charactersIn: "&="))            
            token = data[1]
            userId = data[5]
            performSegue(withIdentifier: "unwindToUserGroup", sender: self)            
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
