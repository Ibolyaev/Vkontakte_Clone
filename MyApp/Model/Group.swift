//
//  Group.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 {
 "id": 1,
 "name": "ВКонтакте API",
 "screen_name": "apiclub",
 "is_closed": 0,
 "type": "group",
 "is_admin": 1,
 "admin_level": 3,
 "is_member": 1,
 "description":
 */

struct Group:Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
        
    let name:String
    let screenName:String
    let id:String
    let usersCount:Int
    let image:UIImage?
    var currentUserInGroup:Bool
    let photoURL:String
    
    init(json:JSON) {
        name = json["name"].stringValue
        screenName = json["screenName"].stringValue
        id = json["id"].stringValue
        // MARK : TODO
        usersCount = 0 // How to get ?
        photoURL = json["photo_medium"].stringValue
        currentUserInGroup = true
        image = nil
    }
    // Demo only
    init(name: String, usersCount: Int, image: UIImage?, currentUserInGroup: Bool) {
        self.name = name
        self.usersCount = usersCount
        self.image = image
        self.currentUserInGroup = currentUserInGroup
        screenName = name
        photoURL = ""
        id = "demo"
    }
    
    static func demoData() -> [Group] {
        
        var userGroups = [Group]()
        
        userGroups.append(Group(name: "Microsoft guys", usersCount: 1000, image: UIImage(named:"Microsoft"), currentUserInGroup: false))
        userGroups.append(Group(name: "Apple guys", usersCount: 2000, image: UIImage(named:"Apple"), currentUserInGroup: true))
        userGroups.append(Group(name: "Fishing lovers", usersCount: 2000, image: UIImage(named:"Fishing"), currentUserInGroup: false))
        userGroups.append(Group(name: "1C", usersCount: 2000, image: UIImage(named:"One"), currentUserInGroup: true))
        
        return userGroups
    }
}
