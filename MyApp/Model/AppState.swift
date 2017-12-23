//
//  AppState.swift
//  MyApp
//
//  Created by Игорь Боляев on 06.12.17.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AppState {
    var token: String? {
        didSet {
            if let token = token {
               KeychainWrapper.standard.set(token, forKey: "token")
            }
            
        }
    }
    var userLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(userLoggedIn, forKey: "userLoggedIn")
        }
    }
    static let shared = AppState()
    private init() {
        userLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        token = KeychainWrapper.standard.string(forKey: "token") ?? nil
    }
    
    func showError(title:String = "We got a problem", with message:String?, viewController:UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {[weak viewController] in
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
