//
//  Group.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Realm

class Group:RLMObject {
        
    @objc dynamic var name:String = ""
    @objc dynamic var screenName:String = ""
    @objc dynamic var id:String = ""
    @objc dynamic var usersCount:Int = 0
    @objc dynamic var currentUserInGroup:Bool = false
    var photo:Photo = Photo(url: "")
    
    convenience init(json:JSON) {
        self.init()
        name = json["name"].stringValue
        screenName = json["screenName"].stringValue
        id = json["gid"].stringValue
        usersCount = 0
        photo = Photo(url:json["photo_medium"].stringValue)
        currentUserInGroup = true
    }
    
}
