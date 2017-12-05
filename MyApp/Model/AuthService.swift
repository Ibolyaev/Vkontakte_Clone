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
    var loginCompletion: ((User, Error?) -> Void)?
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AuthService.loggedIn(_:)),
                                               name: .CloseSafariViewControllerNotification,
                                               object: nil)
    }
    
    func parseURLParameters(from: URL) -> [String:String]? {
        
        var params: [String: String] = [:]
        let components = URLComponents(url: from, resolvingAgainstBaseURL: false)
        
        guard let fragment = components?.fragment else { return nil }
        
        let elements = fragment.components(separatedBy: "&")
        elements.forEach { (element) in
            let formant = element.components(separatedBy: "=")
            guard formant.count > 1 else { return }
            
            params[formant[0]] = formant[1]
        }
        
        guard
            let token = params["access_token"],
            let secret = params["secret"]
            else { return [:] }
        return ["token": token, "secret": secret]
        
    }
    
    @objc func loggedIn(_ notification: Notification? = nil) {
        hideSafari()
        guard
            let notification = notification,
            let url = notification.object as? URL
            else { return }
        
        let parameters = parseURLParameters(from: url)
        guard
            let token = parameters?["token"],
            let secret = parameters?["secret"]
            else { return }
        
        print(token)
        
        /*Server.standard.request(authRequest) { user, error in
            guard let loginCompletion = self.loginCompletion else { return }
            SVProgressHUD.dismiss(completion: {
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
            if let error = error {
                loginCompletion(nil, error)
            } else {
                loginCompletion(user, nil)
            }
        }*/
    }
    
    func showSafari(url: URL) {
        safari = SFSafariViewController(url: url, entersReaderIfAvailable: true)
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
