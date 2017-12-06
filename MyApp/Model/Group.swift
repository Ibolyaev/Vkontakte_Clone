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

class Group:Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
        
    let name:String
    let screenName:String
    let id:String
    let usersCount:Int
    let image:UIImage?
    var currentUserInGroup:Bool
    let photo:Photo
    
    init(json:JSON) {
        name = json["name"].stringValue
        screenName = json["screenName"].stringValue
        id = json["gid"].stringValue
        usersCount = 0
        photo = Photo(url:json["photo_medium"].stringValue)
        currentUserInGroup = true
        image = nil
    }
    
}
