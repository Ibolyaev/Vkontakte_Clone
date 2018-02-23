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
    var userId: Int? {
        didSet {
            if let userId = userId {
                KeychainWrapper.standard.set(userId, forKey: "userId")
            }
        }
    }
    var userLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(userLoggedIn, forKey: "userLoggedIn")
        }
    }
    static let shared = AppState()
    var defaults = UserDefaults(suiteName: "group.lastFriends")
    private init() {
        userLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        token = KeychainWrapper.standard.string(forKey: "token") ?? nil
        userId = KeychainWrapper.standard.integer(forKey: "userId") ?? nil
    }
    
    func saveLastFriendsFrom(_ friends: [User]) {
        var lastFriends = [[String:String]]()
        let items = min(5, friends.count)
        for index in 0..<items {
            let user = friends[index]
            lastFriends.append(["name":user.name, "photoURL": user.photo?.url ?? ""])
        }
        defaults?.setValue(lastFriends, forKey: "lastFriends")
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
