//
//  AppDelegate.swift
//  MyApp
//
//  Created by Ronin on 16/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldUpdateBadge = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if AppState.shared.userLoggedIn {
            self.window?.rootViewController = storyBoard.instantiateViewController(controller: MainTabBarController.self)
        } else {
            self.window?.rootViewController = storyBoard.instantiateViewController(controller: LoginViewController.self)
        }
        UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(30))
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge]) {[weak self] (granted, error) in
            self?.shouldUpdateBadge = granted
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .CloseSafariViewControllerNotification, object: url)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let clientVk = VKontakteAPI()
        clientVk.getFriendsRequests {[weak self] (friends, error) in
            guard var loadedFriends = friends else {
                completionHandler(.failed)
                return
            }
            loadedFriends = loadedFriends.map {$0.friendshipReuqest = true; return $0}
            if self?.shouldUpdateBadge ?? false {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = loadedFriends.count
                }
            }            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(loadedFriends, update: true)
                }
                let usersInDataBaseToDelete = NSPredicate(format: "NOT id IN %@ AND friendshipReuqest == %@", loadedFriends.map {$0.id}, NSNumber(value: true))
                let usersToDelete = realm.objects(User.self).filter(usersInDataBaseToDelete)
                try realm.write {
                    realm.delete(usersToDelete)
                }
                if loadedFriends.count == 0 && usersToDelete.count == 0 {
                    completionHandler(.noData)
                } else {
                    completionHandler(.newData)
                }
                
            } catch {
                completionHandler(.failed)
            }
            
            
        }
    }
}

