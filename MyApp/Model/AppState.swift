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
    
    func quit(_ sender: UIViewController) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
            !rootViewController.isKind(of: LoginViewController.self) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = storyBoard.instantiateViewController(controller: LoginViewController.self)
        } else {
            sender.performSegue(withIdentifier: Constants.SegueIdentifiers.unwindToLogin, sender: sender)
        }        
    }
}
