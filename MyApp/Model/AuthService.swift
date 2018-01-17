//
//  AuthService.swift
//  MyApp
//
//  Created by Ronin on 05/12/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import SafariServices

class AuthService {
    var safari: SFSafariViewController?
    weak var currentViewController: UIViewController?
    var loginCompletion: ((User?, Error?) -> Void)?
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AuthService.loggedIn(_:)),
                                               name: .CloseSafariViewControllerNotification,
                                               object: nil)
    }
    
    func parseURLParameters(from: URL) -> [String:String]? {
        var parameters: [String: String] = [:]
        let components = URLComponents(url: from, resolvingAgainstBaseURL: false)
        
        guard let fragment = components?.fragment else { return nil }
        
        let elements = fragment.components(separatedBy: "&")
        elements.forEach { (element) in
            let formant = element.components(separatedBy: "=")
            guard formant.count > 1 else { return }
            
            parameters[formant[0]] = formant[1]
        }
        
        guard
            let token = parameters["access_token"]
            else { return [:] }
        return ["token": token]
        
    }
    
    @objc func loggedIn(_ notification: Notification? = nil) {
        hideSafari()
        guard
            let notification = notification,
            let url = notification.object as? URL,
            let loginCompletion = loginCompletion
            else { return }
        
        let parameters = parseURLParameters(from: url)
        guard
            let token = parameters?["token"]
            else { return }
        
        VKontakteAPI.getUser(userToken: token) { (user, error) in
            DispatchQueue.main.async {
                if let error = error {
                    loginCompletion(nil, error)
                } else {
                    loginCompletion(user, error)
                }
            }  
        }
    }
    
    func showSafari(url: URL) {
        safari = SFSafariViewController(url: url)
        currentViewController?.present(safari!, animated: true, completion: nil)
    }
    
    func hideSafari() {
        if let safari = safari, safari.isViewLoaded {
            safari.dismiss(animated: false, completion: nil)
        }
    }
}

extension Notification.Name {
    static let CloseSafariViewControllerNotification: Notification.Name = Notification.Name(rawValue: "CloseSafariViewControllerNotification")
}
