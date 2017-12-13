//
//  AppDelegate.swift
//  MyApp
//
//  Created by Ronin on 16/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if AppState.shared.userLoggedIn {
            self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController")
        } else {
            self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .CloseSafariViewControllerNotification, object: url)
        return true
    }


}

