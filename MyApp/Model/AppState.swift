//
//  AppState.swift
//  MyApp
//
//  Created by Игорь Боляев on 06.12.17.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import RealmSwift

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
    let defaultsLastFriends = UserDefaults(suiteName: "group.lastFriends")
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
        defaultsLastFriends?.setValue(lastFriends, forKey: "lastFriends")
    }
    func getlastNews() -> [LastNews]? {
        guard let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.MyApp.LastNews") else {
            assert(false, "group.MyApp.LastNews - Shared group must be in App")
            return nil
        }
        do {
            let realm = try Realm(fileURL: directory.appendingPathComponent("db.realm"))
            let news = realm.objects(LastNews.self)
            return news.map {$0}
        } catch _ {
            return nil
        }
    }
    
    func saveLastNewsFrom(_ news: [News]) {
        let lastNews = news.map { (news) -> LastNews in
            var urlString:String?
            if let attachment = news.attachments?.first {
                switch attachment.type {
                case "photo" : urlString = attachment.photo?.photo_604
                case "video" : urlString = attachment.video?.image
                default :
                    break
                }
            }
            let lastNews = LastNews()
            lastNews.text = news.text ?? ""
            lastNews.photoUrl = urlString ?? ""
            lastNews.title = news.profile?.title ?? ""
            lastNews.id = news.post_id ?? 0
            return lastNews
        }
        guard let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.MyApp.LastNews") else {
            assert(false, "group.MyApp.LastNews - Shared group must be in App")
            return
        }        
        
        do {
            let realm = try Realm(fileURL: directory.appendingPathComponent("db.realm"))
            try realm.write {
                realm.deleteAll()
                realm.add(lastNews)
            }
        } catch let error {
            print(error)
        }
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
