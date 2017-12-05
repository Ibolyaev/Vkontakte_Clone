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
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        NotificationCenter.default.post(name: .CloseSafariViewControllerNotification, object: url)
        //vk6234664://authorize#access_token=148e67c36ad7db648c00f4698646451ee5dfbe42ca43008ef3aed767b0f2a2b95d500a6c7811ccd63a12f&expires_in=0&user_id=6823870&secret=52ce699d8d749329dc&https_required=1
        return true
    }


}

